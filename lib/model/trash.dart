///UploadFunction Trash
///This is used to delete a note from firebase
int count = 0;
// for(int i = 0; i<listOfUpdatedNotes.length;i++){
//
//   if(!(listOfUpdatedNotes[i].docId == listOfLocalNotes[i].docId)){
//     await DatabaseMethods().deleteANote(listOfUpdatedNotes[i].docId);
//     listOfUpdatedNotes.remove(i);
//     sortList();
//     print(listOfUpdatedNotes.length);
//     i = i -1;
//     count++;
//     print('first delete check');
//     if(count > 2){
//       print('was not able to be solve in the first delete check');
//       checkList('local');
//       return null;
//     }
//   }
// }
/// check if u miss any one
// if(listOfDocId.length > listOfUpdatedDocId.length){
//   int counts = 0;
//   for(int i = 0; i<listOfDocId.length;i++){
//
//     if(!(listOfDocId[i].docId == listOfUpdatedDocId[i].docId)){
//       await DatabaseMethods().uploadNotes(listOfDocId[i].toJson());
//       listOfUpdatedDocId.add(listOfDocId[i]);
//       sortList();
//       print(listOfUpdatedDocId.length);
//       i = i -1;
//       counts++;
//       print('first update check');
//       if(counts > 5){
//         print('was not able to be solve in the first update check');
//         checkList('firebase');
//         return null;
//       }
//     }
//   }
// }

// listOfUpdatedDocId.forEach((elements) {
//   print('test');
// listOfDocId.forEach((element) {
//   if(element.docId == elements.docId){
//     DatabaseMethods().deleteANote(elements.docId);
//     print('deleted');
//   }
// });
// });

// if(listOfUpdatedDocId.isNotEmpty){
//   for(int i = 0;i<listOfUpdatedDocId.length;i++){
//     print(listOfUpdatedDocId[i].docId);
//   }
//   for(int i = 0;i<listOfDocId.length;i++){
//     print(listOfDocId[i].docId);
//   }
// }