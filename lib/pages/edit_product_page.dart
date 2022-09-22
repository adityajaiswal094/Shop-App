// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductPage({Key? key}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context)!.settings.arguments as String;

      if (productID != '') {
        _editedProduct =
            Provider.of<ProductsProvider>(context).findById(productID);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageURL': _editedProduct.imageUrl,
          'imageURL': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    //
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      // editing an existing product
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        // adding a new product
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // ignore: prefer_void_to_null
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('An error occured!'),
                content: const Text('Something went wrong.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   // if (mounted) {
      //   Navigator.of(context).pop();
      //   // }
      // }
    }

    //
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //
                        // Title
                        TextFormField(
                          initialValue: _initValue['title'],
                          decoration: const InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a title.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              isFavourite: _editedProduct.isFavourite,
                              id: _editedProduct.id,
                              title: value!,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                        ),

                        // Price
                        TextFormField(
                          initialValue: _initValue['price'],
                          decoration: const InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              isFavourite: _editedProduct.isFavourite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value!),
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a number.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                        ),

                        // Description
                        TextFormField(
                          initialValue: _initValue['description'],
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.words,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                              isFavourite: _editedProduct.isFavourite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value!,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description.';
                            }
                            if (value.length < 10) {
                              return 'Length should be at least 10 characters.';
                            }
                            return null;
                          },
                        ),

                        // Image
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin:
                                  const EdgeInsets.only(top: 8.0, right: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? const Center(child: Text('Enter a URL'))
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                // initialValue: _initValue['imageURL'],
                                decoration: const InputDecoration(
                                    labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                textCapitalization: TextCapitalization.words,

                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    isFavourite: _editedProduct.isFavourite,
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value!,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image URL.';
                                  }
                                  if (!value.startsWith('http://') &&
                                      !value.startsWith('https://')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid image URL.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
