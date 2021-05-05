var firebaseConfig = {
    apiKey: "AIzaSyAwKDlM4kV2HhuDGtIcn8iqFozcJ7aO3sk",
    authDomain: "csapplied-teacher-app-db.firebaseapp.com",
    projectId: "csapplied-teacher-app-db",
    storageBucket: "csapplied-teacher-app-db.appspot.com",
    //messagingSenderId: "628599017742",
    appId: "1:628599017742:web:303ca8b1b79593a26a875f"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

//make auth and firestore references
const auth = firebase.auth();
const db = firebase.firestore();
const functions = firebase.functions(); 

//add admin cloud function
const adminForm = document.querySelector(".admin-actions");
const adminItems = document.querySelector(".admin");
if(adminForm){
    adminForm.addEventListener("submit", (e) => {
        e.preventDefault();
        const adminEmail = document.querySelector("#admin-email").value;
        const addAdminRole = functions.httpsCallable("addAdminRole");
        addAdminRole({ email: adminEmail}).then(result => {
            console.log(result);
        });

    });
}

//userInfo
const userInfo = document.querySelector("#account-details");

if(userInfo){
    auth.onAuthStateChanged(user => {
        if(user){
        
            user.getIdTokenResult().then(idTokenResult => {
                //console.log(idTokenResult.claims);
                user.admin = idTokenResult.claims.admin;
                setupUI(user);
            });
            if(user.admin){
                //adminItems.forEach(item => item.style.display = "block");
            }
            // else{
            //     adminItems.forEach(item => item.style.display = "none");
            // }
            //get user info in the teachers collection using user id
            var userName;
            db.collection('teachers').doc(user.uid).get().then((snapshot) => {
                userName = snapshot.data()["firstName"] + snapshot.data()["lastName"];
             });
            const html =    `
                <div>User email:  ${user.email}</div>
                <div>User name:  ${userName}</div>

                <div>${user.admin ? 'Admin' : ''}</div>
            `;
            userInfo.innerHTML = html;

        }
        //console.log(user);
    });
}

const loginForm = document.querySelector("#loginform");

if(loginForm){
    loginForm.addEventListener("submit", (e) => {
        e.preventDefault();

        //get mail and pword
        const email = loginForm['login-email'].value;
        const password = loginForm['login-password'].value;
    
        auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL)
        .then(() => {
            // Existing and future Auth states are now persisted in the current
            // session only. Closing the window would clear any existing state even
            // if a user forgets to sign out.
            // ...
            // New sign-in will be persisted with session persistence.
            return auth.signInWithEmailAndPassword(email, password).then(cred => {
                //console.log(cred.user);
                //loginForm.reset();

                console.log("Successful login!");
                

            });
        })
        .catch((error) => {
            // Handle Errors here.
            var errorCode = error.code;
            var errorMessage = error.message;
            console.log(errorCode);
            window.alert("Message: " + errorMessage);
        });
    });
}

const signupForm = document.querySelector("#register");

if(signupForm){
    signupForm.addEventListener('submit',(e) => {
        e.preventDefault();

        //get user info
        const email = signupForm['signup-email'].value;
        const password = signupForm['txtPassword'].value;
        const confirmpassword = signupForm['txtConfirmPassword'].value;
 
        if(password != confirmpassword){
            alert("Passwords do not match");
        }else{
            auth.createUserWithEmailAndPassword(email,password)
            .then((userCredential) => {
                // Signed in 
                var user = userCredential.user;
                //console.log(user.data());
                // add teacher to users collection
                return db.collection('users').doc(user.uid).set({
                    email: user.email,
                });
            })
            .catch((error) => {
                var errorCode = error.code;
                var errorMessage = error.message;
                // ..
            });
        }
            
        
    
    });

}

const subjectlist = document.querySelector("#selectsubject");
//get subjects
if(subjectlist){
    auth.onAuthStateChanged(user =>{
        if(user){
            user.getIdTokenResult().then(idTokenResult => {
                //console.log(idTokenResult.claims);
                user.admin = idTokenResult.claims.admin;
                setupUI(user);
            });

        }
     });
    
    function renderSubjects(doc){
        var firstname, lastname, teacher_longitude, teacher_latitude,
        teacher_gender,teacher_email,teacher_school,teacher_bio;
        
        let li = document.createElement('li');
        let subject = document.createElement('span');
        let theplus = document.createElement('div');
    
        li.setAttribute('data-id',doc.id);
        subject.textContent = doc.data().subject_name;
        theplus.textContent = '+';
    
        li.appendChild(subject);
        li.appendChild(theplus);
        subjectlist.appendChild(li);    
        
    
        //add teaccher to a particular subject subcollection
        theplus.addEventListener('click',(e) => {
            e.stopPropagation();
            let subjectid = e.target.parentElement.getAttribute('data-id');
            var user  = firebase.auth().currentUser;
            db.collection('teachers').doc(user.uid).get().then((doc) => {
                firstname= doc.data()['firstName'];
                lastname = doc.data()['lastName'];
                teacher_school = doc.data()['school'];
                teacher_email = doc.data()['userEmail'];
                //teacher_bio = doc.data()['bio'];
            });
            db.collection('userlocations').where('userid', '==',user.uid).get().then((querySnapshot) => {
                querySnapshot.forEach((doc) => {
                    console.log(doc.id,'=>',doc.data());
                    teacher_latitude = doc.data()['latitude'];
                    teacher_longitude = doc.data()['longitude'];
                });
            }).catch((error) => {
                console.log("Error getting documents: ",error);
            });
            if(firstname == null || teacher_latitude == null){
                alert("Process failed. Please try again...");
            }else{
    
                db.collection('subjects').doc(subjectid).collection('teachersubject').doc(user.uid).set({
                    teacherId: user.uid,
                    teacherName: firstname + " " + lastname,
                    teacher_lat: teacher_latitude,
                    teacher_long: teacher_longitude,
                    //teachersex: teacher_gender,
                    teachermail: teacher_email,
                    teacherschool: teacher_school,
                    //teacherbio: teacher_bio,
                });
        }
        });
        
    
    }
    
    db.collection('subjects').get().then((snapshot) => {
        //console.log(snapshot.docs);
        snapshot.docs.forEach(doc => {
            renderSubjects(doc);        
        });
    });
}

//render subjects for admin
const subjectlistAdmin = document.querySelector("#adminsubject");
const form = document.querySelector("#add-subject-form");

//get subjects
if(subjectlistAdmin){
    function renderSubjectsAdmin(doc){
        let li = document.createElement('li');
        let subjectname = document.createElement('span');
        let cross = document.createElement('div');

        li.setAttribute('data-id', doc.id);
        subjectname.textContent = doc.data().subject_name;
        cross.textContent = 'x';

        li.appendChild(subjectname);
        li.appendChild(cross);
        subjectlistAdmin.appendChild(li);

        //delete subject
        cross.addEventListener('click', (e) => {
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
            db.collection('subjects').doc(id).delete();

        });
        
    }

    //get data(subjects) in real-time using realtime listener
    db.collection('subjects').orderBy("subject_name","asc").onSnapshot(snapshot => {
        let changes = snapshot.docChanges();
        changes.forEach(change => {
            if(change.type == 'added'){
                renderSubjectsAdmin(change.doc);            
            }else if(change.type == 'removed'){
                let li = subjectlistAdmin.querySelector('[data-id=' + change.doc.id + ']');
                subjectlistAdmin.removeChild(li);
            }
        });

    });
}

//add subjects for admin
if(form){
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        var form_value = form.subject.value;
        if(form_value != ""){
            db.collection("subjects").add({
                subject_name: form_value,
            });
            form.subject.value = '';
        }else{
            window.alert("Subject field is empty!");
        }
        
    });
}

const verificationDetails = document.querySelector("#pending-details-form");
if(verificationDetails){
    verificationDetails.addEventListener('submit',(e) => {
        var user = firebase.auth().currentUser;
        //console.log("The id is: ", user.uid);
        var fname = verificationDetails['first-name'].value;
        var lname = verificationDetails['last-name'].value;
        var schl = verificationDetails['school'].value;
        var subj = verificationDetails['subject'].value;
        var adrss = verificationDetails['school-address'].value;
        var tel = verificationDetails['school-tel'].value;
        var mail = verificationDetails['school-email'].value;
        console.log(fname);

        if(schl != null && subj != null){
        
            db.collection('pendingaccounts').doc(user.uid).set({        
                firstName: fname,
                lastName: lname,
                school: schl,
                usermail: user.email,
                subject: subj,
                schoolAddress: adrss,
                schoolTel: tel,
                schoolEmail: mail,
            });  
        }
      
    });
}

const homeForm = document.querySelector("#home-id");
if(homeForm){
    auth.onAuthStateChanged(user =>{
        if(user){
            user.getIdTokenResult().then(idTokenResult => {
                //console.log(idTokenResult.claims);
                user.admin = idTokenResult.claims.admin;
                setupUI(user);
            });

        }
     });

}

const teachersList = document.querySelector("#teachers-id");
if(teachersList){
    console.log("Display teachers here");
}
//function to send email to successful teacher
function sendEmail(recieverEmail, receiverFname, recieverLname) {
	Email.send({
	Host: "smtp.gmail.com",
	Username : "nearbyteacherfinder@gmail.com",
	Password : "atn??@/552021",
	To : recieverEmail,//`${recieverEmail}`,
	From : "nearbyteacherfinder@gmail.com",
	Subject : "Request Approved",
	Body : `<div>Dear ${receiverFname} ${recieverLname},</div><br>
            <div>Your request to use the Nearby Teacher Finder as a tutor has been approved. you
            can now access other features of the system. Kindly log in to your account and update your details.</div>
            <div>Regards,<br/>The Nearby Teacher Finder Team.</div> `,
	}).then(
		message => alert("mail sent successfully to: " + recieverEmail)
	);
}

//rejected user
function sendEmailRejected(recieverEmail, receiverFname, recieverLname) {
	Email.send({
	Host: "smtp.gmail.com",
	Username : "nearbyteacherfinder@gmail.com",
	Password : "atn??@/552021",
	To : recieverEmail,//`${recieverEmail}`,
	From : "nearbyteacherfinder@gmail.com",
	Subject : "Request Declined",
	Body : `<div>Dear ${receiverFname} ${recieverLname},</div><br>
            <div>Your request to use the Nearby Teacher Finder as a tutor has been declined. This comes after cross-checking
            the information you provided with the institution you provided.</div>
            <div>Regards,<br/>The Nearby Teacher Finder Team.</div> `,
	}).then(
		message => alert("mail sent successfully to: " + recieverEmail)
	);
}

const teacherRequests = document.querySelector("#requests-id");
if(teacherRequests){
    
    function renderPendingTeachers(doc){
        let li = document.createElement('li');
        let teacherName = document.createElement('span');
        let seeDetails = document.createElement('button');
        let reject = document.createElement('button');
        let approve = document.createElement('button');

    
        li.setAttribute('data-id', doc.id);
        var fullName = doc.data().firstName + " " + doc.data().lastName;
        teacherName.textContent = fullName;
        seeDetails.textContent = "Details";
        approve.textContent = "Approve";
        reject.textContent = "Reject";
    
        li.appendChild(teacherName);
        li.appendChild(seeDetails)
        li.appendChild(approve);
        li.appendChild(reject);
    
        teacherRequests.appendChild(li);
        seeDetails.addEventListener('click', (e) => {
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
            togglePopup();

            const pendingDetails = document.querySelector('#pending-details');
            function renderRequestDetails(doc){
                
                let div = document.createElement('div');
                let school = document.createElement('div');
                let email = document.createElement('div');
                let schoolAddress = document.createElement('div');
                let schoolTel = document.createElement('div');
                let subject = document.createElement('div');
                let userEmail = document.createElement('div');
            
                div.setAttribute('data-id',doc.id);
                school.textContent = "School: " + doc.data().school;
                email.textContent = "School Email: " + doc.data().schoolEmail;
                schoolAddress.textContent = "School Address: " + doc.data().schoolAddress;
                schoolTel.textContent = "School Tel: " + doc.data().schoolTel;
                subject.textContent = "Teacher subject: " + doc.data().subject;
                userEmail.textContent = "Teacher Email: " + doc.data().usermail;
            
                div.appendChild(school);
                div.appendChild(email);
                div.appendChild(schoolAddress);
                div.appendChild(schoolTel);
                div.appendChild(subject);
                div.appendChild(userEmail);
            
                pendingDetails.appendChild(div);
                
            
            }
            db.collection('pendingaccounts').doc(id).get().then((snapshot) => {
               
                    //renderConvos(doc);
                    //console.log(snapshot.data());
                    renderRequestDetails(snapshot);
                
                
            });

        });
    
    
        //approving teachers
        var fname, lname, dob, gender, school,usermail, bio;
        approve.addEventListener('click',(e) =>{
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
            var pendingUsers = db.collection('pendingaccounts').doc(id);
            pendingUsers.get().then((doc) => {

                fname = doc.data()['firstName'];
                lname = doc.data()['lastName'];
                // dob = doc.data()['dateOfBirth'];
                // gender = doc.data()['gender'];
                school = doc.data()['school'];
                usermail =  doc.data()['usermail'];
               // bio = doc.data()['bio'];
               // db.collection('pendingaccounts').doc(id).delete();           
            });
            if(fname != null){
                console.log(doc.data());
                sendEmail(usermail, fname, lname);
                
                db.collection('teachers').doc(id).set({
                    firstName: fname,
                    lastName: lname,
                    //dateOfBirth: dob,
                    //gender: gender,
                    //location: gender,
                    school: school,
                    userEmail: usermail,
                    //bio: bio,
                });
                db.collection('pendingaccounts').doc(id).delete();
            }
        });
    
        // //rejecting teachers
        reject.addEventListener('click',(e) => {
            e.stopPropagation();
            sendEmailRejected(usermail, fname, lname);
            let id = e.target.parentElement.getAttribute('data-id');
            db.collection('pendingaccounts').doc(id).delete();
        });
    
    }
    
    db.collection('pendingaccounts').get().then((snapshot) => {
        //console.log(snapshot);
        snapshot.docs.forEach(doc => {
            renderPendingTeachers(doc);
        });
    });
    
}

//grab chatrooms
const chatrooms = document.querySelector("#chatrooms-id");
if(chatrooms){
    auth.onAuthStateChanged(user =>{
        if(user){
            user.getIdTokenResult().then(idTokenResult => {
                //console.log(idTokenResult.claims);
                user.admin = idTokenResult.claims.admin;
                setupUI(user);
            });
    
    //create element and render chatrooms
    function renderChatrooms(doc){
        let li = document.createElement('li');
        let chatroomId = document.createElement('span');
        let arrow = document.createElement('div');

        li.setAttribute('data-id',doc.id);
        chatroomId.textContent = doc.data().chatroomId;
        arrow.textContent = '>';

        li.appendChild(chatroomId);
        li.appendChild(arrow);

        chatrooms.appendChild(li);

        //redirecting to the conversations page
        arrow.addEventListener('click', (e) =>{
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
           // console.log(id);
            //window.location.href = '/teacheradminapp/conversations.html';
            togglePopup();
            
            const msgForm = document.querySelector('#message-form');

           
            db.collection('chatroom').doc(id).collection('chats').orderBy('time',"asc").get().then((snapshot) => {
                snapshot.docs.forEach(doc => {
                    renderConvos(doc);
                    //console.log(doc.data());
                });
                
            });

            msgForm.addEventListener('submit', (e) => {
                e.preventDefault();
                db.collection('chatroom').doc(id).collection('chats').add({
                    message: msgForm.message.value,
                    sendBy: user.email,
                    time: Date.now(),
                });
                msgForm.message.value = '';
            });
        });
    }
    
            console.log(user.email);
            db.collection('chatroom').where("users", "array-contains", user.email).get().then((snapshot) => {
                snapshot.docs.forEach(doc => {
                    renderChatrooms(doc);
                });
            });

        }
    });
    
    //console.log(auth.currentUser.email);
}

//logout
const logout = document.querySelector("#logout");
if(logout){
    logout.addEventListener("click",(e) => {
        //e.preventDefault();
        auth.signOut().then(() => {
            window.location.href = '/index.html';
        });
        //alert("signed out");
    });
}

function togglePopup(){
    document.getElementById("popup-1").classList.toggle("active");
}




// function verificMail(params, pfname){
//     var tempParams = {
//         from_name: "Nearby Teacher Finder",
//         to_name: pfname,
//         message: " "
//     };

//     emailjs.send('service_mreb1nr','template_er80h1i',tempParams).then(function(res){

//     })
// }

//render conversations
const convMessages = document.querySelector('#my-convos');
function renderConvos(doc){
                
    let li = document.createElement('li');
    let message = document.createElement('span');

    li.setAttribute('data-id',doc.id);
    message.textContent = doc.data().message;

    li.appendChild(message);

    convMessages.appendChild(li);

}


//show a popup to get user's location
const loginPopup = document.querySelector(".login-popup");
const close = document.querySelector(".close");

if(loginPopup){
    window.addEventListener("load",function(){

    showPopup();
    // setTimeout(function(){
    //   loginPopup.classList.add("show");
    // },5000)

    });
}

function showPopup(){
      const timeLimit = 5 // seconds;
      let i=0;
      const timer = setInterval(function(){
       i++;
       if(i == timeLimit){
        clearInterval(timer);
        loginPopup.classList.add("show");
       } 
       console.log(i)
      },1000);
}
    if(close){
        close.addEventListener("click",function(){
            loginPopup.classList.remove("show");
          });
}



//get user's location
const trackLocation = document.querySelector('#location-btn');
if(trackLocation){
    
    auth.onAuthStateChanged(user => {
        if(user){
            /*checks if user exists in the userlocations collection. The doc Id is User Id.
            If it does not exist, it will add the doc to the collection*/
            const userLocations = db.collection('userlocations').doc(user.uid);

       
            trackLocation.addEventListener('click',(e) => {
                e.preventDefault();
                //console.log("We are here bitches");
                const successCallback = (position) => {
                    console.log(position);
                    const lati = position.coords.latitude;
                    const longi = position.coords.longitude;
                    userLocations.get().then((docSnapshot) => {
                        if(docSnapshot.exists){
                            userLocations.onSnapshot((doc) => {
                                console.log("Already exists");
                            });
                        }else{
                            userLocations.set({
                                userid: user.uid,
                                latitude: lati,
                                longitude: longi,
                            });
                        }
                    });
                }
                const errorCallback = (error) => {
                    console.error(error);
                }
                navigator.geolocation.getCurrentPosition(successCallback,errorCallback);          
        

            });
        }
    });
}


//closes popup when "Allow" button is clocked
function toggleLocationPopup(){
    let theDiv = document.getElementById("popup-id");
    if(theDiv.style.visibility === 'hidden'){
        theDiv.style.visibility = 'visible';
      } else {
        theDiv.style.visibility = 'hidden';
      }
}

const profilePicView = document.querySelector("#id-profile-pic-view");
const teacherDetailsId = document.querySelector("#update-info-view");
let img = document.getElementById("img"),
    profileUpdate = document.getElementById("profile-update");
//updating user details


// function updateTeacherDetails(){
//     stopPropagation();
//     //update profile db should come here
//     // auth.onAuthStateChanged(user => {
//     //     firebase.storage().ref('updatedTeacherDetails/' + user.uid + '/profile.jpg').put(file).then(function(){
//     //         console.log("successfully uploaded");
//     //     }).catch(err => {
//     //         console.log(err.message);
//     //     });;
//     // });
//     //alert("Funny bitch");
//     console.log("Funny I lost my drive when I lost card");

// }
let file = {};
function chooseFile(e){
    file = e.target.files[0];
}
if(teacherDetailsId){
    teacherDetailsId.addEventListener('click', (e) => {
        e.preventDefault();
        //update profile db should come here
        auth.onAuthStateChanged(user => {
            firebase.storage().ref('updatedTeacherDetails/' + user.uid + file.name).put(file).then(function(){
                console.log("successfully uploaded");
            }).catch(err => {
                console.log(err.message);
            });;
        });
        //console.log("Funny bitch");
    });
}

//get user profile picture
auth.onAuthStateChanged(user => {
    if(user){
        firebase.storage().ref('updatedTeacherDetails/' + user.uid + file.name).getDownloadURL().then(imgUrl => {
            console.log(imgUrl);
            console.log("File name is" + file.name);
            img.src = imgUrl;
        });
    }
});

//display teachers 
const teachersId = document.querySelector("#teachers-id");
if(teachersId){
    function renderTeachers(doc){
        let li = document.createElement('li');
        let teacherName = document.createElement('span');
        let arrow_forward = document.createElement('div');

        li.setAttribute('data-id',doc.id);
        teacherName.textContent = doc.data().firstName + " " + doc.data().lastName;
        arrow_forward.textContent = '>';

        li.appendChild(teacherName);
        li.appendChild(arrow_forward);

        teachersId.appendChild(li);

        //displaying teachers info
        arrow_forward.addEventListener('click', (e) => {
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
            togglePopup();

            const techerDetails = document.querySelector('#teacher-details');
            function renderTeacherDetails(doc){
                
                let div = document.createElement('div');
                let school = document.createElement('div');
                let email = document.createElement('div');
            
                div.setAttribute('data-id',doc.id);
                school.textContent = "School: " + doc.data().school;
                email.textContent = "Email: " + doc.data().userEmail ;
            
                div.appendChild(school);
                div.appendChild(email);
            
                techerDetails.appendChild(div);
                
            
            }
            db.collection('teachers').doc(id).get().then((snapshot) => {
               
                    //renderConvos(doc);
                    //console.log(snapshot.data());
                    renderTeacherDetails(snapshot);
                
                
            });

        });

        
    }
    db.collection('teachers').get().then((snapshot) =>{
        snapshot.docs.forEach(doc => {
            //console.log(doc.data());
            renderTeachers(doc);
        })
    })

}

//pupils details
const pupilsId = document.querySelector("#pupils-id");
if(pupilsId){
    function renderPupils(doc){
        let li = document.createElement('li');
        let pupilName = document.createElement('span');
        let arrow_forward = document.createElement('div');

        li.setAttribute('data-id',doc.id);
        pupilName.textContent = doc.data().fname + " " + doc.data().lname;
        arrow_forward.textContent = '>';

        li.appendChild(pupilName);
        li.appendChild(arrow_forward);

        pupilsId.appendChild(li);

        //displaying teachers info
        arrow_forward.addEventListener('click', (e) => {
            e.stopPropagation();
            let id = e.target.parentElement.getAttribute('data-id');
            togglePopup();

            const techerDetails = document.querySelector('#pupil-details');
            function renderPupilDetails(doc){
                
                let div = document.createElement('div');
                let school = document.createElement('div');
                let email = document.createElement('div');
            
                div.setAttribute('data-id',doc.id);
                school.textContent = "School: " + doc.data().company;
                email.textContent = "Email: " + doc.data().userId;
            
                div.appendChild(school);
                div.appendChild(email);
            
                techerDetails.appendChild(div);
                
            
            }
            db.collection('tutors').doc(id).get().then((snapshot) => {
               
                    //renderConvos(doc);
                    //console.log(snapshot.data());
                    renderPupilDetails(snapshot);
                
                
            });

        });

        
    }
    db.collection('tutors').get().then((snapshot) =>{
        snapshot.docs.forEach(doc => {
            //console.log(doc.data());
            renderPupils(doc);
        })
    })

}