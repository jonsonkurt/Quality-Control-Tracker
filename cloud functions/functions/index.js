const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.inspectorsSendPendingNotification = functions
    .region('asia-southeast1')
    .database.ref('projectUpdates/{projectUPID}')
    .onCreate(async (snapshot, context) => {
        const getData = snapshot.val();

        // pending
        if (getData.hasOwnProperty('inspectorID')) {
            const { inspectorID, projectID } = getData;

            try {
                // Get the device token or user ID associated with the appointmentId
                // Inspector Token
                const snapshot = await admin.database()
                    .ref(`/inspectors/${inspectorID}/fcmInspectorToken`)
                    .once('value');
                const deviceToken = snapshot.val();

                //project FName
                const snapshot2 = await admin.database()
                    .ref(`/projects/${projectID}/projectName`)
                    .once('value');
                const projectName = snapshot2.val();

                const message = {
                    token: deviceToken,
                    notification: {
                        title: 'New Inspection Request',
                        body: `You have a new inpection request for ${projectName}.`,
                    },
                };

                // Send the message
                admin.messaging().send(message)
                    .then((response) => {
                        // Handle the response
                        console.log('Successfully sent notification 1:', response);
                    })
                    .catch((error) => {
                        // Handle the error
                        console.error('Error sending notification 1:', error);
                    });
            } catch (error) {
                console.error('Error sending push notification 1:', error);
            }
        }
    })

exports.responsiblepartySendPendingNotification = functions
    .region('asia-southeast1')
    .database.ref('projectUpdates/{projectUPID}/rpProjectRemarks')
    .onUpdate(async (change, context) => {
        const newStatus = change.after.val();
        const statusComponents = newStatus.split('-');
        const strippedStatus = statusComponents.map(component => component.trim());

        // pending
        if (strippedStatus[2] === 'REWORK') {
            try {
                // Get the device token or user ID associated with the appointmentId
                // RP Token
                const snapshot = await admin.database()
                    .ref(`/responsibleParties/${strippedStatus[0]}/fcmToken`)
                    .once('value');
                const deviceToken = snapshot.val();

                //project FName
                const snapshot2 = await admin.database()
                    .ref(`/projects/${strippedStatus[1]}/projectName`)
                    .once('value');
                const projectName = snapshot2.val();

                const message = {
                    token: deviceToken,
                    notification: {
                        title: 'New Rework Request',
                        body: `The work submitted in ${projectName} needs rework.`,
                    },
                };

                // Send the message
                admin.messaging().send(message)
                    .then((response) => {
                        // Handle the response
                        console.log('Successfully sent notification 2:', response);
                    })
                    .catch((error) => {
                        // Handle the error
                        console.error('Error sending notification 2:', error);
                    });
            } catch (error) {
                console.error('Error sending push notification 2:', error);
            }
        }
    })