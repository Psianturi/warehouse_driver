class HistoryResponse {
  Meta? meta;
  List<Data>? data;

  HistoryResponse({this.meta, this.data});

  HistoryResponse.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? code;
  String? status;
  String? message;
  bool? isPaginated;

  Meta({this.code, this.status, this.message, this.isPaginated});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    isPaginated = json['is_paginated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_paginated'] = this.isPaginated;
    return data;
  }
}

class Data {
  int? id;
  String? trNumber;
  Transaction? transaction;
  String? status;
  IdTrackDriver? idTrackDriver;
  double? lat;
  double? long;
  double? elevasi;
  double? kecepatan;
  int? battery;

  Data(
      {this.id,
        this.trNumber,
        this.transaction,
        this.status,
        this.idTrackDriver,
        this.lat,
        this.long,
        this.elevasi,
        this.kecepatan,
        this.battery});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trNumber = json['tr_number'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    status = json['status'];
    idTrackDriver = json['id_track_driver'] != null
        ? new IdTrackDriver.fromJson(json['id_track_driver'])
        : null;
    lat = json['lat'];
    long = json['long'];
    elevasi = json['elevasi'];
    kecepatan = json['kecepatan'];
    battery = json['battery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tr_number'] = this.trNumber;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    data['status'] = this.status;
    if (this.idTrackDriver != null) {
      data['id_track_driver'] = this.idTrackDriver!.toJson();
    }
    data['lat'] = lat;
    data['long'] = long;
    data['elevasi'] = elevasi;
    data['kecepatan'] = kecepatan;
    data['battery'] = battery;
    return data;
  }
}

class Transaction {
  int? id;
  String? trNumber;
  int? productId;
  String? productName;
  Product? product;
  String? unit;
  int? priceBuy;
  int? priceSale;
  int? high;
  int? wide;
  int? length;
  int? quantity;
  int? totalBuy;
  int? totalSale;
  int? quarryId;
  Quarry? quarry;
  String? photoProductSend;
  String? photoProductReceive;
  String? photoNoteSend;
  String? photoNoteReceive;
  String? status;
  int? userSendId;
  UserSend? userSend;
  int? userReceiveId;
  UserSend? userReceive;
  int? warehouseId;
  Quarry? warehouse;
  int? transportId;
  Transport? transport;
  int? invoiceId;
  Invoice? invoice;
  String? sendAt;
  String? receiveAt;
  String? statusAt;
  String? updatedAt;
  String? createdAt;

  Transaction(
      {this.id,
        this.trNumber,
        this.productId,
        this.productName,
        this.product,
        this.unit,
        this.priceBuy,
        this.priceSale,
        this.high,
        this.wide,
        this.length,
        this.quantity,
        this.totalBuy,
        this.totalSale,
        this.quarryId,
        this.quarry,
        this.photoProductSend,
        this.photoProductReceive,
        this.photoNoteSend,
        this.photoNoteReceive,
        this.status,
        this.userSendId,
        this.userSend,
        this.userReceiveId,
        this.userReceive,
        this.warehouseId,
        this.warehouse,
        this.transportId,
        this.transport,
        this.invoiceId,
        this.invoice,
        this.sendAt,
        this.receiveAt,
        this.statusAt,
        this.updatedAt,
        this.createdAt, required transactionData});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trNumber = json['tr_number'];
    productId = json['product_id'];
    productName = json['product_name'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    unit = json['unit'];
    priceBuy = json['price_buy'];
    priceSale = json['price_sale'];
    high = json['high'];
    wide = json['wide'];
    length = json['length'];
    quantity = json['quantity'];
    totalBuy = json['total_buy'];
    totalSale = json['total_sale'];
    quarryId = json['quarry_id'];
    quarry =
    json['quarry'] != null ? Quarry.fromJson(json['quarry']) : null;
    photoProductSend = json['photo_product_send'];
    photoProductReceive = json['photo_product_receive'];
    photoNoteSend = json['photo_note_send'];
    photoNoteReceive = json['photo_note_receive'];
    status = json['status'];
    userSendId = json['user_send_id'];
    userSend = json['user_send'] != null
        ? new UserSend.fromJson(json['user_send'])
        : null;
    userReceiveId = json['user_receive_id'];
    userReceive = json['user_receive'] != null
        ? new UserSend.fromJson(json['user_receive'])
        : null;
    warehouseId = json['warehouse_id'];
    warehouse = json['warehouse'] != null
        ? new Quarry.fromJson(json['warehouse'])
        : null;
    transportId = json['transport_id'];
    transport = json['transport'] != null
        ? new Transport.fromJson(json['transport'])
        : null;
    invoiceId = json['invoice_id'];
    invoice =
    json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    sendAt = json['send_at'];
    receiveAt = json['receive_at'];
    statusAt = json['status_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['tr_number'] = trNumber;
    data['product_id'] = productId;
    data['product_name'] = productName;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['unit'] = unit;
    data['price_buy'] = priceBuy;
    data['price_sale'] = priceSale;
    data['high'] = high;
    data['wide'] = wide;
    data['length'] = length;
    data['quantity'] = quantity;
    data['total_buy'] = totalBuy;
    data['total_sale'] = totalSale;
    data['quarry_id'] = quarryId;
    if (quarry != null) {
      data['quarry'] = quarry!.toJson();
    }
    data['photo_product_send'] = this.photoProductSend;
    data['photo_product_receive'] = this.photoProductReceive;
    data['photo_note_send'] = this.photoNoteSend;
    data['photo_note_receive'] = this.photoNoteReceive;
    data['status'] = this.status;
    data['user_send_id'] = this.userSendId;
    if (this.userSend != null) {
      data['user_send'] = this.userSend!.toJson();
    }
    data['user_receive_id'] = this.userReceiveId;
    if (this.userReceive != null) {
      data['user_receive'] = this.userReceive!.toJson();
    }
    data['warehouse_id'] = this.warehouseId;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.toJson();
    }
    data['transport_id'] = this.transportId;
    if (this.transport != null) {
      data['transport'] = this.transport!.toJson();
    }
    data['invoice_id'] = this.invoiceId;
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.toJson();
    }
    data['send_at'] = this.sendAt;
    data['receive_at'] = this.receiveAt;
    data['status_at'] = this.statusAt;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  int? quarryId;
  String? unit;
  int? priceBuy;
  int? priceSale;
  String? updatedAt;
  String? createdAt;

  Product(
      {this.id,
        this.name,
        this.quarryId,
        this.unit,
        this.priceBuy,
        this.priceSale,
        this.updatedAt,
        this.createdAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quarryId = json['quarry_id'];
    unit = json['unit'];
    priceBuy = json['price_buy'];
    priceSale = json['price_sale'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quarry_id'] = this.quarryId;
    data['unit'] = this.unit;
    data['price_buy'] = this.priceBuy;
    data['price_sale'] = this.priceSale;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Quarry {
  int? id;
  String? name;
  String? location;
  String? updatedAt;
  String? createdAt;

  Quarry({this.id, this.name, this.location, this.updatedAt, this.createdAt});

  Quarry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class UserSend {
  int? id;
  String? deviceId;
  String? deviceName;
  String? email;
  String? phone;
  String? name;
  int? roleId;
  int? quarryId;
  int? warehouseId;
  String? photo;

  UserSend(
      {this.id,
        this.deviceId,
        this.deviceName,
        this.email,
        this.phone,
        this.name,
        this.roleId,
        this.quarryId,
        this.warehouseId,
        this.photo});

  UserSend.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['device_id'];
    deviceName = json['device_name'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    roleId = json['role_id'];
    quarryId = json['quarry_id'];
    warehouseId = json['warehouse_id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['device_id'] = this.deviceId;
    data['device_name'] = this.deviceName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['role_id'] = this.roleId;
    data['quarry_id'] = this.quarryId;
    data['warehouse_id'] = this.warehouseId;
    data['photo'] = this.photo;
    return data;
  }
}

class Transport {
  int? id;
  String? number;
  String? type;
  String? driver;
  int? high;
  int? wide;
  int? length;
  int? volume;
  int? quarryId;
  String? updatedAt;
  String? createdAt;

  Transport(
      {this.id,
        this.number,
        this.type,
        this.driver,
        this.high,
        this.wide,
        this.length,
        this.volume,
        this.quarryId,
        this.updatedAt,
        this.createdAt});

  Transport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    type = json['type'];
    driver = json['driver'];
    high = json['high'];
    wide = json['wide'];
    length = json['length'];
    volume = json['volume'];
    quarryId = json['quarry_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['type'] = this.type;
    data['driver'] = this.driver;
    data['high'] = this.high;
    data['wide'] = this.wide;
    data['length'] = this.length;
    data['volume'] = this.volume;
    data['quarry_id'] = this.quarryId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Invoice {
  int? id;
  String? number;
  int? quantity;
  int? total;
  int? userId;
  String? status;
  String? photoInvoice;
  String? updatedAt;
  String? createdAt;

  Invoice(
      {this.id,
        this.number,
        this.quantity,
        this.total,
        this.userId,
        this.status,
        this.photoInvoice,
        this.updatedAt,
        this.createdAt});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    quantity = json['quantity'];
    total = json['total'];
    userId = json['user_id'];
    status = json['status'];
    photoInvoice = json['photo_invoice'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['photo_invoice'] = this.photoInvoice;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class IdTrackDriver {
  int? id;
  String? trNumber;
  String? status;
  UserSend? user;
  String? numberVehicle;

  IdTrackDriver(
      {this.id, this.trNumber, this.status, this.user, this.numberVehicle});

  IdTrackDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trNumber = json['tr_number'];
    status = json['status'];
    user = json['user'] != null ? new UserSend.fromJson(json['user']) : null;
    numberVehicle = json['number_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tr_number'] = this.trNumber;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['number_vehicle'] = this.numberVehicle;
    return data;
  }
}
