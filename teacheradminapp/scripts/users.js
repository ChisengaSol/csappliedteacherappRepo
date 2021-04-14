// var firebaseConfig = {
//     apiKey: "AIzaSyAwKDlM4kV2HhuDGtIcn8iqFozcJ7aO3sk",
//     authDomain: "csapplied-teacher-app-db.firebaseapp.com",
//     projectId: "csapplied-teacher-app-db",
//     //storageBucket: "csapplied-teacher-app-db.appspot.com",
//     //messagingSenderId: "628599017742",
//     appId: "1:628599017742:web:303ca8b1b79593a26a875f"
// };
// // Initialize Firebase
// firebase.initializeApp(firebaseConfig);

//make auth and firestore references
//const auth = firebase.auth();
//const db = firebase.firestore();
//const functions = firebase.functions(); 

const accountDetails = document.querySelector('.account-details');
const adminTabs = document.querySelectorAll('.admin');
const setupUI = (user) => {
    if(user.admin){
        //console.log(user);
        adminTabs.forEach(item => item.style.display = 'block');
        // db.collection('teachers').doc(user.uid).get().then(doc => {
        //     //account info
        //     const html =`
        //       <div>Email: ${user.email}</div>
        //       <div>Name: ${doc.data().firstName} ${doc.data().lastName}</div>
        //       <div>D.O.B: ${doc.data().dateOfBirth}</div>
        //       <div class ="pink-text"> ${user.admin ? 'Admin' : ''}</div>
        //     `;
        //     accountDetails.innerHTML = html;
        //   });

    }else{
      adminTabs.forEach(item => item.style.display = 'none');

    }
}