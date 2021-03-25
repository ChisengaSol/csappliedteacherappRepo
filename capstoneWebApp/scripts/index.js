const subjectsList = document.querySelector('.subjectsadmin');
const subjectsListTeacher = document.querySelector('.subjectsteacher');
const pupilsList = document.querySelector('.pupils');
const teachersList = document.querySelector('.teachers');

//get logged in or logged out pages
const loggedOutLinks = document.querySelectorAll('.logged-out');
const loggedInLinks = document.querySelectorAll('.logged-in');
const accountDetails = document.querySelector('.account-details');
const adminItems = document.querySelectorAll('.admin');

const setupUI = (user) => {
  if(user){
    if(user){
      if(user.admin){
        adminItems.forEach(item => item.style.display= 'block');
      }
    }
    db.collection('teachers').doc(user.uid).get().then(doc => {
      //account info
      const html =`
        <div>Email: ${user.email}</div>
        <div>Name: ${doc.data().firstName} ${doc.data().lastName}</div>
        <div>D.O.B: ${doc.data().dateOfBirth}</div>
        <div class ="pink-text"> ${user.admin ? 'Admin' : ''}</div>
      `;
      accountDetails.innerHTML = html;
    });  

    //toggle UI elements
    loggedInLinks.forEach(item => item.style.display = 'block');
    loggedOutLinks.forEach(item => item.style.display = 'none');
  }else{
    adminItems.forEach(item => item.style.display= 'none');
    //hide user info
    accountDetails.innerHTML = '';

    //toggle UI elements
    loggedInLinks.forEach(item => item.style.display = 'none');
    loggedOutLinks.forEach(item => item.style.display = 'block');
  }
}

//setup subjects admin
// const setupSubjects = (data) =>{

//   if(data.length){
//   let html = '';
//   data.forEach(doc => {
//     const subject = doc.data();

//     //these backstrock quotes create a template string
//     const li = `
//       <form id="deletesubject-form">
//         <li>
//           <div class="collapsible-header grey lighten-4" id="delete-subject">${subject.subject_name}  <button class="btn blue darken-2 z-depth-0">Remove</button></div>
//         </li>
//       </form>
//     `;

//     html += li;
//   });

//   subjectsList.innerHTML = html;
// }else{
//   //if user is not logged in
//   subjectsList.innerHTML = '<h5 class = "center-align">You are not logged in</h5>'
// }
// }

//setup subjects teacher
// const setupSubjectsTeacher = (data) =>{

//   if(data.length){
//   let html = '';
//   data.forEach(doc => {
//     const subject = doc.data();

//     //these backstrock quotes create a template string
//     const li = `
//         <li>
//           <div class="collapsible-header grey lighten-4" id="select-subject"><input type="text" id="addsubjectname" value = "${subject.subject_name}" readonly> <button class="btn blue darken-2 z-depth-0">SELECT</button></div>
//         </li>      
//     `;

//     html += li;
//   });

//   subjectsListTeacher.innerHTML = html;
// }else{
//   //if user is not logged in
//   subjectsListTeacher.innerHTML = '<h5 class = "center-align">You are not logged in</h5>'
// }
// }

//set pupils
const setupPupils = (data) =>{

  if(data.length){
  let html = '';
  data.forEach(doc => {
    const pupil = doc.data();

    //these backstrock quotes create a template string
    const li = `
      <li>
        <div class="collapsible-header grey lighten-4">${pupil.fname} ${pupil.lname}</div>
        <div class="collapsible-body white">${pupil.lname}</div>
      </li>
    `;

    html += li;
  });

  pupilsList.innerHTML = html;
}else{
  //if user is not logged in
  pupilsList.innerHTML = '<h5 class = "center-align">You are not logged in</h5>'
}
}

//set teachers
const setupTeachers = (data) =>{

  if(data.length){
  let html = '';
  data.forEach(doc => {
    const teacher = doc.data();

    //these backstrock quotes create a template string
    const li = `
      <li>
        <div class="collapsible-header grey lighten-4">${teacher.firstName} ${teacher.lastName}</div>
        <div class="collapsible-body white">${teacher.lastName}</div>
      </li>
    `;

    html += li;
  });

  teachersList.innerHTML = html;
}else{
  //if user is not logged in
  teachersList.innerHTML = '<h5 class = "center-align">You are not logged in</h5>'
}
}


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