import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:prud_central/screens/home_screen.dart';
//import 'package:prud_central/screens/lunch_screen.dart';

class UserModel extends Model {
  final pageController = PageController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);
      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;

      await loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass({
    @required String email,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> photo(
      {@required Map<String, dynamic> profile,
      @required VoidCallback onSuccess}) async {
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(profile);
    isLoading = true;
    isLoading = false;
    notifyListeners();
    onSuccess();
  }

  Future<Null> message({
    @required Map<String, dynamic> mssg,
  }) async {
    await Firestore.instance
        .collection('messages')
        .add(mssg)
        .then((message) async {
      await Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .collection('messages')
          .document(message.documentID)
          .setData({'messageId': message.documentID, 'hora': Timestamp.now()});
    });
  }

// lembrar de colocar um identificador em cada pedido pra saber a que coleção ele realmente pertence.

  Future<Null> sendOrder({
    @required Map<String, dynamic> order,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    await Firestore.instance
        .collection("Pedidos")
        .add(order)
        .then((lunch) async {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("orders")
          .document(lunch.documentID)
          .setData({
        'orderId': lunch.documentID,
        'hora': Timestamp.now(),
        'userId': firebaseUser.uid,
      });
      isLoading = false;
      notifyListeners();

      onSuccess();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();

      onFail();
    });
  }

  Future<Null> sendOrderEgg(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    await Firestore.instance
        .collection("PedidosOvo")
        .add(order)
        .then((egg) async {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("ordersE")
          .document(egg.documentID)
          .setData({
        'orderId': egg.documentID,
        'hora': Timestamp.now(),
        'userId': firebaseUser.uid,
      });
      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  Future<Null> sendOrderRice(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    await Firestore.instance
        .collection("PedidosArroz")
        .add(order)
        .then((rice) async {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("ordersR")
          .document(rice.documentID)
          .setData({
        'orderId': rice.documentID,
        'hora': Timestamp.now(),
        'userId': firebaseUser.uid,
      });
      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  Future<Null> sendOrderRaE(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    await Firestore.instance
        .collection("PedidosOvo")
        .add(order)
        .then((orderRE) async {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("ordersE")
          .document(orderRE.documentID)
          .setData({
        'orderId': orderRE.documentID,
        'hora': Timestamp.now(),
        'userId': firebaseUser.uid,
      });
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("ordersR")
          .document(orderRE.documentID)
          .setData({
        'orderId': orderRE.documentID,
        'hora': Timestamp.now(),
        'userId': firebaseUser.uid,
      });

      await Firestore.instance
          .collection("PedidosArroz")
          .document(orderRE.documentID)
          .setData(order);
      isLoading = false;
      notifyListeners();
      onSuccess();
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      onFail();
    });
  }

  Future<Null> removeOrder(
      {@required orderId,
      @required String category,
      @required String type,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    try {
      isLoading = true;
      notifyListeners();

      await Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .collection(type)
          .document(orderId)
          .delete()
          .then((_) async {
        await Firestore.instance
            .collection(category)
            .document(orderId)
            .delete();
      });

      isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      onFail();
    }
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
  }

  Future savedUser(BuildContext context) async {
    if (firebaseUser != null) {
      loadCurrentUser().then((_) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeWidget()));
      });
    }
  }

  notifyListeners();
}
