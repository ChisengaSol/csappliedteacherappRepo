//get data from db
db.collection('guides').get().then(snapshot => {
    setupGuides(snapshot.docs);
});

//listen for auth status change
auth.onAuthStateChanged(user => {
    
    if(user){
        //get data from db
        db.collection('guides').onSnapshot(snapshot => {
        setupGuides(snapshot.docs);
        setupUI(user);
        }, err =>{
            console.log(err.message);
        });

    }else{
        //if user is not signed in, empty array displays nothing
        setupUI();
        setupGuides([]);
    }
});

//get subjects from db
// db.collection('subjects').get().then(snapshot => {
//     setupSubjects(snapshot.docs);
// });

// //listen for auth status change
// auth.onAuthStateChanged(user => {
    
//     if(user){
//         //get data from db
//         db.collection('subjects').onSnapshot(snapshot => {
//         setupSubjects(snapshot.docs);
//         setupUI(user);
//         }, err =>{
//             console.log(err.message);
//         });

//     }else{
//         //if user is not signed in, empty array displays nothing
//         setupUI();
//         setupSubjects([]);
//     }
// });

//create new guide
const createForm = document.querySelector('#create-form');
createForm.addEventListener('submit',(e) => {
    e.preventDefault();

    db.collection('guides').add({
        title: createForm['title'].value,
        content: createForm['content'].value
    }).then(() => {
        //close the modal and reset form
        const modal = document.querySelector('#modal-create');
        M.Modal.getInstance(modal).close();
        createForm.reset();
    }).catch(err =>{
      console.log(err.message); 
    });
});


//signup
const signupForm = document.querySelector('#signup-form');
signupForm.addEventListener('submit',(e) => {
   e.preventDefault();

   //get user info
   const email = signupForm['signup-email'].value;
   const password = signupForm['signup-password'].value;

   //sign up the user
   auth.createUserWithEmailAndPassword(email,password).then(cred => {
       return db.collection('teachers').doc(cred.user.uid).set({
           firstName: signupForm['signup-fname'].value,
           lastName: signupForm['signup-lname'].value,
           dateOfBirth: signupForm['signup-dob'].value,
           gender: signupForm['signup-gender'].value,
           location: signupForm['signup-location'].value,
           bio: signupForm['signup-bio'].value
       });
       
   }).then(() => {
       //close signup modal and reset the form
        const modal = document.querySelector('#modal-signup');
        M.Modal.getInstance(modal).close();
        signupForm.reset();
   });

});

//logout
const logout =document.querySelector('#logout');
logout.addEventListener('click',(e) => {
    e.preventDefault();
    auth.signOut().then();
});


//login
const loginForm = document.querySelector('#login-form');
loginForm.addEventListener('submit',(e) => {
   e.preventDefault();

   //get user info
   const email = loginForm['login-email'].value;
   const password = loginForm['login-password'].value;

   auth.signInWithEmailAndPassword(email,password).then(cred => {
       const modal = document.querySelector('#modal-login');
       M.Modal.getInstance(modal).close();
       loginForm.reset();    
   });

});


