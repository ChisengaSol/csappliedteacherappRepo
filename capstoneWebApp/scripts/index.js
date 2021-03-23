const guideList = document.querySelector('.guides');
//const subjectsList = document.querySelector('.subjects');

//get logged in or logged out pages
const loggedOutLinks = document.querySelectorAll('.logged-out');
const loggedInLinks = document.querySelectorAll('.logged-in');
const accountDetails = document.querySelector('.account-details');

const setupUI = (user) => {
  if(user){
    db.collection('teachers').doc(user.uid).get().then(doc => {
      //account info
      const html =`
        <div>Email: ${user.email}</div>
        <div>Name: ${doc.data().firstName} ${doc.data().lastName}</div>
        <div>D.O.B: ${doc.data().dateOfBirth}</div>
      `;
      accountDetails.innerHTML = html;
    });  

    //toggle UI elements
    loggedInLinks.forEach(item => item.style.display = 'block');
    loggedOutLinks.forEach(item => item.style.display = 'none');
  }else{
    //hide user info
    accountDetails.innerHTML = '';

    //toggle UI elements
    loggedInLinks.forEach(item => item.style.display = 'none');
    loggedOutLinks.forEach(item => item.style.display = 'block');
  }
}

//setup guides
const setupGuides = (data) =>{

  if(data.length){
  let html = '';
  data.forEach(doc => {
    const guide = doc.data();

    //these backstrock quotes create a template string
    const li = `
      <li>
        <div class="collapsible-header grey lighten-4">${guide.title}</div>
        <div class="collapsible-body white">${guide.content}</div>
      </li>
    `;

    html += li;
  });

  guideList.innerHTML = html;
}else{
  //if user is not logged in
  guideList.innerHTML = '<h5 class = "center-align">Welcome message</h5>'
}
}

//set up subjects
// const setupSubjects = (data) =>{

//   if(data.length){
//   let html = '';
//   data.forEach(doc => {
//     const subject = doc.data();

//     //these backstrock quotes create a template string
//     const li = `
//       <li>
//         <div class="collapsible-header grey lighten-4">${subject.subject_name}</div>
//       </li>
//     `;

//     html += li;
//   });

//   subjectsList.innerHTML = html;
// }else{
//   //if user is not logged in
//   subjectsList.innerHTML = '<h5 class = "center-align">You are not logged in</h5>'
// }
// }

//setup subjects UI
// const setupSubjectsUI = (user) => {
//   if(user){
//     db.collection('subjects').get().then(doc => {
//       //account info
//       const html =`
//         <div>Logged in as ${user.email}</div>
//         <div>Logged in as ${doc.data().firstName}</div>
//       `;
//       accountDetails.innerHTML = html;
//     });  

//     //toggle UI elements
//     loggedInLinks.forEach(item => item.style.display = 'block');
//     loggedOutLinks.forEach(item => item.style.display = 'none');
//   }else{
//     //hide user info
//     accountDetails.innerHTML = '';

//     //toggle UI elements
//     loggedInLinks.forEach(item => item.style.display = 'none');
//     loggedOutLinks.forEach(item => item.style.display = 'block');
//   }
// }

// setup materialize components
document.addEventListener('DOMContentLoaded', function() {

  var modals = document.querySelectorAll('.modal');
  M.Modal.init(modals);

  var items = document.querySelectorAll('.collapsible');
  M.Collapsible.init(items);

});