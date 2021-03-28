//add admin cloud function
const adminForm = document.querySelector('.admin-actions');
adminForm.addEventListener('submit',(e) => {
    e.preventDefault();
    const adminEmail = document.querySelector('#admin-email').value;
    const addAdminRole = functions.httpsCallable('addAdminRole');
    addAdminRole({email: adminEmail}).then(result => {
        console.log(result);
    });
});

//get data from db
// db.collection('subjects').get().then(snapshot => {
//     setupSubjects(snapshot.docs);
// });

//listen for auth status change
auth.onAuthStateChanged(user => {
    
    if(user){
        user.getIdTokenResult().then(idTokenResult => {
          user.admin = idTokenResult.claims.admin; 
          setupUI(); 
        });
        //get data from db
        // db.collection('subjects').onSnapshot(snapshot => {
        // setupSubjects(snapshot.docs);
        // setupUI(user);
        // }, err =>{
        //     console.log(err.message);
        // });

        //get pupils
        db.collection('tutors').onSnapshot(snapshot => {
        setupPupils(snapshot.docs);
        setupUI(user);
        }, err =>{
            console.log(err.message);
        });

        //get teachers
        db.collection('teachers').onSnapshot(snapshot => {
        setupTeachers(snapshot.docs);
        setupUI(user);
        }, err =>{
            console.log(err.message);
        });

        // db.collection('subjects').onSnapshot(snapshot => {
        // setupSubjectsTeacher(snapshot.docs);
        // setupUI(user);
        // }, err =>{
        //     console.log(err.message);
        // });

    }else{
        //if user is not signed in, empty array displays nothing
        
        //setupSubjects([]);
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

//create new subject
const createForm = document.querySelector('#create-form');
createForm.addEventListener('submit',(e) => {
    e.preventDefault();

    db.collection('subjects').add({
        subject_name: createForm['subjectname'].value,
        //content: createForm['content'].value
    }).then(() => {
        //close the modal and reset form
        const modal = document.querySelector('#modal-create');
        M.Modal.getInstance(modal).close();
        createForm.reset();
    }).catch(err =>{
      console.log(err.message); 
    });
});

//add selected subjects
// const selectSubjectForm = document.querySelector('#selectsubject-form');
// selectSubjectForm.addEventListener('submit',(e) => {
//     e.preventDefault();


//     db.collection('teachersubject').add({
        
//         subject_name: selectSubjectForm['addsubjectname'].value,
//         //content: createForm['content'].value
//     }).then(() => {
//         //close the modal and reset form
//         const modal = document.querySelector('#modal-teacher-subjects');
//         M.Modal.getInstance(modal).close();
//         selectSubjectForm.reset();
//     }).catch(err =>{
//       console.log(err.message); 
//     });
// });

//get subjects for teacher
const subjectList = document.querySelector('#selectsubject');

//create elements and render subjects
function renderSubjects(doc){
    let li = document.createElement('li');
    let subject = document.createElement('span');

    li.setAttribute('data-id',doc.id);
    subject.textContent = doc.data().subject_name;

    li.appendChild(subject);

    subjectList.appendChild(li);
    

}

db.collection('subjects').get().then((snapshot) => {
    //console.log(snapshot.docs);
    snapshot.docs.forEach(doc => {
        renderSubjects(doc);        
    });
});

//get subjects for admin
const subjectListAdmin = document.querySelector('#admin-subjects');

//create elements and render subjects
function renderSubjectsAdmin(doc){
    let li = document.createElement('li');
    let subject = document.createElement('span');
    let cross = document.createElement('div');

    li.setAttribute('data-id',doc.id);
    subject.textContent = doc.data().subject_name;
    cross.textContent = 'x';

    li.appendChild(subject);
    li.appendChild(cross);

    subjectListAdmin.appendChild(li);

    //deleting subject
    cross.addEventListener('click', (e) =>{
        e.stopPropagation();
        let id = e.target.parentElement.getAttribute('data-id');
        db.collection('subjects').doc(id).delete();

    })
    

}

db.collection('subjects').get().then((snapshot) => {
    //console.log(snapshot.docs);
    snapshot.docs.forEach(doc => {
        renderSubjectsAdmin(doc);        
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
       return db.collection('pendingaccounts').doc(cred.user.uid).set({
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
        signupForm.querySelector('.error').innerHTML = '';
   }).catch(err => {
       signupForm.querySelector('.error').innerHTML = err.message;
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
       loginForm.querySelector('.error').innerHTML = '';   
   }).catch(err => {
    loginForm.querySelector('.error').innerHTML = err.message;
   });

});

//Get pending requests for admin
const pendingTeacherRequestsList = document.querySelector('#pending-teachers-list');

//render pending teachers
function renderPendingTeachers(doc){
    let li = document.createElement('li');
    let pfname = document.createElement('span');
    let plname = document.createElement('span');
    let reject = document.createElement('div');
    let approve = document.createElement('div');

    li.setAttribute('data-id', doc.id);
    pfname.textContent = doc.data().firstName;
    plname.textContent = doc.data().lastName;
    approve.textContent = "Approve";
    reject.textContent = "Reject";

    li.appendChild(pfname);
    li.appendChild(plname);
    li.appendChild(approve);
    li.appendChild(reject);

    pendingTeacherRequestsList.appendChild(li);

    //approving teachers
    var fname, lname, dob, gender, location, bio;
    approve.addEventListener('click',(e) =>{
        e.stopPropagation();
        let id = e.target.parentElement.getAttribute('data-id');
        var pendingUsers = db.collection('pendingaccounts').doc(id);
        pendingUsers.get().then((doc) => {
            fname = doc.data()['firstName'];
            lname = doc.data()['lastName'];
            dob = doc.data()['dateOfBirth'];
            gender = doc.data()['gender'];
            location = doc.data()['location'];
            bio = doc.data()['bio'];
            //db.collection('pendingaccounts').doc(id).delete();
           
        });
        if(fname != null){
            db.collection('teachers').doc(id).set({
                firstName: fname,
                lastName: lname,
                dateOfBirth: dob,
                gender: gender,
                location: gender,
                bio: bio,
            });
            db.collection('pendingaccounts').doc(id).delete();
        }
    });

    //rejecting teachers
    reject.addEventListener('click',(e) => {
        e.stopPropagation();
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

//delete subejct
// const deleteSubjectForm = document.querySelector('#deletesubject-form');

// deleteSubjectForm.addEventListener('click',(e) => {
//     e.preventDefault();

//     db.collection("subjects").doc("subject_name").delete().then(() => {
//         console.log("Subject successfully deleted!");
//     }).catch((error) => {
//         console.error("Error removing subject: ", error);
//     });

// })


