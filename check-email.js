const imaps = require('imap-simple');

const config = {
    imap: {
        user: 'avaopenclaw@outlook.com',
        password: 'PPbA3hHCyuCl4S9I!@#',
        host: 'outlook.office365.com',
        port: 993,
        tls: true,
        authTimeout: 10000
    }
};

async function checkEmail() {
    try {
        const connection = await imaps.connect(config);
        await connection.openBox('INBOX');
        
        const searchCriteria = ['UNSEEN'];
        const fetchOptions = {
            bodies: ['HEADER', 'TEXT'],
            markSeen: false
        };
        
        const messages = await connection.search(searchCriteria, fetchOptions);
        
        for (const item of messages) {
            const all = item.parts.find(part => part.which === '');
            const id = item.attributes.uid;
            const idHeader = "Message ID: " + id;
            
            console.log(idHeader);
            console.log('Subject:', item.parts[0].body.subject[0]);
            console.log('From:', item.parts[0].body.from[0]);
            console.log('---');
        }
        
        connection.end();
    } catch (err) {
        console.error('Error:', err.message);
    }
}

checkEmail();
