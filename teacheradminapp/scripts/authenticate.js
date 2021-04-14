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

const loginForm = document.querySelector("#loginform");

if(loginForm){
loginForm.addEventListener("submit", (e) => {
     e.preventDefault();

     //get mail and pword
     const email = loginForm['login-email'].value;
     const password = loginForm['login-password'].value;
    console.log(email);
    console.log(password);
 
    auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL)
    .then(() => {
        // Existing and future Auth states are now persisted in the current
        // session only. Closing the window would clear any existing state even
        // if a user forgets to sign out.
        // ...
        // New sign-in will be persisted with session persistence.
        return auth.signInWithEmailAndPassword(email, password).then(cred => {
            console.log(cred.user);
            //loginForm.reset();

            console.log("redirect");

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

const subjectlist = document.querySelector("#selectsubject");
//get subjects
function renderSubjects(doc){
    let li = document.createElement('li');
    let subjectname = document.createElement('span');

    li.setAttribute('data-id', doc.id);
    subjectname.textContent = doc.data().subject_name;

    li.appendChild(subjectname);
    subjectlist.appendChild(li);
    
}
db.collection("subjects").get().then((snapshot) => {
    snapshot.docs.forEach(doc => {
        renderSubjects(doc);
    });
});


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
