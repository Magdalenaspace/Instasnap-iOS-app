//
//  Constants.swift
//  FashionSnap
//
//  Created by Magdalena Samuel on 9/5/23.
//

import Firebase
//creates a reference to a collection in Firestore called users. This collection can be used to store data about users, get the data from this collection, you can use the getDocuments()
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWINGS = Firestore.firestore().collection("followings")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")



//The line of code let COLLECTION_USERS = Firestore.firestore().collection("users") declares a constant named COLLECTION_USERS that is a reference to a collection in Firestore called "users".
//
//Firestore is a NoSQL database that is used to store and retrieve data in the cloud. Collections are groups of documents in Firestore. Documents are the basic unit of storage in Firestore. They can contain any type of data, such as strings, numbers, objects, and arrays.
//
//The Firestore.firestore() method returns a reference to the Firestore client. The collection() method returns a reference to a collection in Firestore.
