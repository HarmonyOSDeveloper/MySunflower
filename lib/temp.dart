// if (addr.text != "" && token.text != "") {
                    //   var uri;
                    //   bool isreal = false;
                    //   try {
                    //     print(
                    //         "http://${addr.text}/api/islegitsunflowercompatableserver");
                    //     uri = Uri.parse(
                    //         "http://${addr.text}/api/islegitsunflowercompatableserver");
                            
                    //     isreal = uri.isAbsolute;
                    //   } catch (identifier) {
                    //     isreal = false;
                    //   }
                    //   if (isreal) {
                    //     try {
                    //       http.get(uri).then((resp) {
                    //         try{
                    //           resp;
                    //         }
                    //         on IOException{
                    //           print(":(");
                    //         }
                    //         print('#1');
                    //         if (resp.statusCode == 200) {
                    //           print('#2');
                    //           var valid2 = false;
                    //           var data = "";
                    //           try {
                    //             data = jsonDecode(resp.body)["value"];
                    //             valid2 = true;
                    //           } catch (identifier) {
                    //             //The Response is not valid.
                    //             //Do Something
                    //           }
                    //           if (valid2) {
                    //             if (data == "1") {
                    //               //Right!
                    //               http.get(
                    //                   Uri.parse(
                    //                       "http://${addr.text}/api/remcode"),
                    //                   headers: {
                    //                     'code': token.text
                    //                   }).then((resp2) {
                    //                 var data2 = jsonDecode(resp.body)["value"];
                    //                 if (data2 == "1") {
                    //                 } else {
                    //                   //Token Code Invalid
                    //                 }
                    //               });
                    //             } else if (data == "0") {
                    //               //Not Setup,(USE PC)
                    //             } else {
                    //               //Invalid Server
                    //             }
                    //           }
                    //         } else {
                    //           //Not Valid Resp Code.
                    //         }
                    //       });
                    //     } catch (er) {
                    //       //Do Something
                    //     }
                    //   } else {
                    //     //Parse URL (Invalid Url)
                    //   }
                    // } else {
                    //   //Show Toast
                    // }
                    