const nodemailer = require('nodemailer');

const sysMail = 'monqezapp@gmail.com';
const password = 'Monqez123@';

let system_main_mail = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: sysMail,
        pass: password
    }
});

module.exports =
{

    sendMail(targetMail , subjectText , body){
        return new Promise( async (resolve, reject) => {
            let system_main_mail = nodemailer.createTransport({
                service: "gmail",
                auth: {
                    user: sysMail,
                    pass: password,
                },
            });

            let info = await system_main_mail.sendMail({
                from: sysMail, // sender address
                to: targetMail, // list of receivers
                subject: subjectText, // Subject line
                text: body, // plain text body
                html: "<b>" + body + "</b>", // html body
            });
            resolve(info);
        } );
    }
}