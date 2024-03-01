import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_clean_architecture/src/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_clean_architecture/src/presentation/widget/add_user.dart';
import 'package:tdd_clean_architecture/src/presentation/widget/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getUsers() async {
    await context.read<AuthenticationCubit>().getUser();
  }

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/imagesUSer_appBar.jpeg'))),
            ),
            title: const Text(
              'User List',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
          body: state is GettingUser
              ? const LoadingColumn(message: 'Loading User')
              : state is CreatingUser
                  ? const LoadingColumn(message: 'Creating User')
                  : state is UserLoaded
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(2, 2),
                                          blurRadius: 1)
                                    ]),
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(user.avatar)
                                      //Image.network(),
                                      ),
                                  title: Text(
                                    '${user.name[0].toUpperCase()}${user.name.substring(1)}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle:
                                      Text(user.createdAt.substring(0, 10)),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color.fromRGBO(255, 55, 150, 1),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddUser(nameController: nameController),
              );
              nameController.text = '';
            },
            label: const Text(
              'Add User',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
