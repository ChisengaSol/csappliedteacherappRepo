var firebaseConfig = {
    apiKey: "AIzaSyAwKDlM4kV2HhuDGtIcn8iqFozcJ7aO3sk",
    authDomain: "csapplied-teacher-app-db.firebaseapp.com",
    projectId: "csapplied-teacher-app-db",
    //storageBucket: "csapplied-teacher-app-db.appspot.com",
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
            const html =    `
                <div>User email:  ${user.email}</div>
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
        // console.log(email);
        // console.log(password);
    
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
//////////////////////
//signup
// $(function () {
//     $("#btnSubmit").click(function () {
//         var password = $("#txtPassword").val();
//         var confirmPassword = $("#txtConfirmPassword").val();
//         if (password != confirmPassword) {
//             alert("Passwords do not match.");
//             return false;
//         }
//         return true;
//     });
// });
const signupForm = document.querySelector("#register");

if(signupForm){
    signupForm.addEventListener('submit',(e) => {
        e.preventDefault();
    
        //get user info
        const email = signupForm['signup-email'].value;
        const password = signupForm['txtPassword'].value;
        const confirmpassword = signupForm['txtConfirmPassword'].value;
        // console.log(email);
        // console.log(password);

        if(password != confirmpassword){
            alert("Passwords do not match");
        }else{
            auth.createUserWithEmailAndPassword(email,password)
            .then((userCredential) => {
                // Signed in 
                var user = userCredential.user;
                console.log(user.data());
                // ...
            })
            .catch((error) => {
                var errorCode = error.code;
                var errorMessage = error.message;
                // ..
            });
        }
            
        
    
    });

}
/////////////////////////////////////////////////////////////////////

const subjectlist = document.querySelector("#selectsubject");
//get subjects
if(subjectlist){
    // function renderSubjects(doc){
    //     let li = document.createElement('li');
    //     let subjectname = document.createElement('span');

    //     li.setAttribute('data-id', doc.id);
    //     subjectname.textContent = doc.data().subject_name;

    //     li.appendChild(subjectname);
    //     subjectlist.appendChild(li);
        
    // }
    // db.collection("subjects").get().then((snapshot) => {
    //     snapshot.docs.forEach(doc => {
    //         renderSubjects(doc);
    //     });
    // });
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
                teacher_gender = doc.data()['gender'];
                teacher_school = doc.data()['school'];
                teacher_email = doc.data()['userEmail'];
                teacher_bio = doc.data()['bio'];
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
                    teachersex: teacher_gender,
                    teachermail: teacher_email,
                    teacherschool: teacher_school,
                    teacherbio: teacher_bio,
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


//logout
const logout = document.querySelector("#logout");
if(logout){
    logout.addEventListener("click",(e) => {
        //e.preventDefault();
        auth.signOut().then(() => {
            window.location.href = '/authentication.html';
        });
        alert("signed out");
    });
}


