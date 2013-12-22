public class newOpportunityController {

	/** Member valiable */
    Account account;
    Contact contact;
    Opportunity opportunity;
    OpportunityContactRole role;


	/** Gettor Method */
    public Account getAccount() {
        if(account == null) account = new Account();
        return account;
    }
    public Contact getContact() {
        if(contact == null) contact = new Contact();
        return contact;
    }
    public Opportunity getOpportunity() {
        if(opportunity == null) opportunity = new Opportunity();
        return opportunity;
    }
    public OpportunityContactRole getRole() {
        if(role == null) role = new OpportunityContactRole();
        return role;
    }


	/** Navigation Method */
    public PageReference step1() {
        return Page.opptyStep1;
        }

    public PageReference step2() {
        return Page.opptyStep2;
    }

    public PageReference step3() {
        return Page.opptyStep3;
    }


	/** Action Method */
    public PageReference cancel() {
        PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
        opportunityPage.setRedirect(true);
        return opportunityPage;
    }

    public PageReference save() {
        // Create the account. Before inserting, copy the contact's
        // phone number into the account phone number field.
        account.phone = contact.phone;
        insert account;
        // Create the contact. Before inserting, use the id field
        // that's created once the account is inserted to create
        // the relationship between the contact and the account.
        contact.accountId = account.id;
        insert contact;
        // Create the opportunity. Before inserting, create
        // another relationship with the account.
        opportunity.accountId = account.id;
        insert opportunity;
        // Create the junction contact role between the opportunity
        // and the contact.
        role.opportunityId = opportunity.id;
        role.contactId = contact.id;
        insert role;
        // Finally, send the user to the detail page for
        // the new opportunity.
        PageReference opptyPage = new ApexPages.StandardController(opportunity).view();
        opptyPage.setRedirect(true);
        return opptyPage;
    }
}