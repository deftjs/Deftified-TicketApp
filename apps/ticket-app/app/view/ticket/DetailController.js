/**
 * This controller manages the User details view which are added as tabs (so multiple
 * instances are created). Each instance of the view creates an instance of this class to
 * control its behavior.
 */
Ext.define('Ticket.view.ticket.DetailController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.ticketdetail',
    
    onSaveClick: function() {
        var form = this.getReference('form'),
            rec,
            session, batch;
        
        if (form.isValid()) {
            session = this.getSession();
            rec = this.getViewModel().getData().theTicket;
            
            if (!session.contains(rec)) {
                session.add(rec);
            }

            batch = session.getSaveBatch();
            if (batch) {
                //TODO Use Ext.Msg.progress to display something while the Batch is saving.
                batch.start();
            } else {
                Ext.Msg.show({
                    title: 'Save',
                    message: 'No changes to save',
                    icon: Ext.Msg.INFO,
                    buttons: Ext.Msg.OK
                });
            }
        }
    }
});
