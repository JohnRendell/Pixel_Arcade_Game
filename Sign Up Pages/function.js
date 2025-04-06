async function createAccount(){
    var username_input = document.getElementById("userInput");
    var password_input = document.getElementById("passInput");
    var confirm_passInput = document.getElementById("confirm_passInput");

    if(!username_input.value || !password_input.value || !confirm_passInput.value){
        alert("Fields cannot be empty")
    }

    else if(username_input.value.length <= 4){
        alert("username characters should alteast five above")
    }

    else if(password_input.value.length <= 6){
        alert("password characters should alteast six above")
    }

    else if(password_input.value !== confirm_passInput.value){
        alert("password and confirm password not match")
    }

    else{
        try{
            const create_acc = await fetch("/validate/signup", {
                method: "POST",
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ username: username_input.value, password: password_input.value })
            });

            const create_acc_data = await create_acc.json();

            if(create_acc_data.message === "success"){
                window.location.href = "/success";
            }
            else{
                alert(create_acc_data.message)
            }
        }
        catch(err){
            alert(err)
        }
    }
}