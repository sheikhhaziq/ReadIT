import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/providers/category_providers.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController();
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create Category"),
      content: TextField(
        controller: categoryController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: 'Category Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final res = await ref
                .read(categoryControllerProvider.notifier)
                .addCategory(categoryController.text);
            if (res && mounted) {
              Navigator.pop(context);
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
