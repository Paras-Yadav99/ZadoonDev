import { LightningElement,track,api,wire } from 'lwc';
import getOpportunityDetails from '@salesforce/apex/showOppOnOpportunityController.getOpportunityDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const columns=[{label:'Name',fieldName:'recordLink', type:'url',
typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' }
},
{label:'Buyer Account Name',fieldName:'AccountName',type:'text'},
{label:'Unit Name',fieldName:'UnitName',type:'text'},
{label:'Starting Retail Price ',fieldName:'StartingRetailPrice',type:'number'},
{label:'Offer Amount',fieldName:'offerAmount',type:'number'},
{label:'Lowest Purchase Price',fieldName:'lowestPurchasePrice',type:'number'},
{label:'Total Pro Forma Cost',fieldName:'totalCost',type:'number'},
{label:'Primary Contact',fieldName:'PrimaryContact',type:'text'},
{label:'Buyer Mobile Number',fieldName:'BuyerMobileNumber',type:'text'},
{label:'CloseDate',fieldName:'CloseDate',type:'date'},
];
export default class showOppOnOpportunity extends LightningElement {
    
    @api recordId;
    @track getRecordId= [];
    @track wonOppRecords;
    @track wonRecords;
    @track lostOppRecords;
    @track lostRecords;
    @track error;
    @track data;
    @track showSpinner = false;
    @track isWonData = false;
    @track isLostData = false;
    columns = columns;
   

    connectedCallback(){
        this.spinnerToggle();
        this.init();    
        this.spinnerToggle();   

    }

    init() {
        getOpportunityDetails({recordId : this.recordId})
        .then(result =>{
            if(result.isSuccess) {
                let parentWrapper = JSON.parse(result.response);
                    this.wonRecords = parentWrapper.closeWonOpportunity;
                    this.wonOppRecords = this.createCustomUrlRecord(this.wonRecords);
                    this.checkWonData(this.wonOppRecords);
                    this.lostRecords = parentWrapper.closeLostOpportunity;
                    this.lostOppRecords = this.createCustomUrlRecord(this.lostRecords); 
                    this.checkLostData(this.lostOppRecords);
                    this.error = undefined;  
            } else {
                this.showToast('error', result.message, result.response);
            }
         
        })
        .catch(error =>{
            this.showToast('error', error.message, error.body);
        });
 
    }
    checkWonData(data){
        if(data.length>0){
            this.isWonData = true;
        } 
    }

    checkLostData(data){
        if(data.length>0){
            this.isLostData = true;
        } 
    }


    spinnerToggle() {
        this.showSpinner = !this.showSpinner;
    }

    showToast( variant,
                    title,
                    message) {
        const event = new ShowToastEvent({
            variant : variant,
            title: title,
            message: message,
        });
        this.dispatchEvent(event);
    }
    
    createCustomUrlRecord(data){

        var tempOppList = [];  
        for (var i = 0; i < data.length; i++) {  
            let tempRecord = Object.assign({},data[i]); //cloning object  
            tempRecord.recordLink = "/" + tempRecord.Id;  
            tempOppList.push(tempRecord);  
        }  
        return tempOppList;
    }
}