import { LightningElement, api, track } from 'lwc';
import getIntialData from "@salesforce/apex/inspectionReportMainController.getIntialData";
import handleSaveData from "@salesforce/apex/inspectionReportMainController.handleSaveData";
import My_Resource from '@salesforce/resourceUrl/Zadoonlogo';
import uploadFile from "@salesforce/apex/inspectionReportMainController.uploadFile";
import createIntialData from "@salesforce/apex/inspectionReportMainController.createIntialData";



export default class InspectionReportMain extends LightningElement {
    zadoonLogo = My_Resource + '/logo.png';
    @track mapData = [];
    @track mapPhotoData = [];
    @track completeDataTest = [];
    @api unitId;
    @track viewMode = false;
    @track loader = false;
    @track showFormPage = true;
    @track reportType;
    @track unitZid;
    @track ShowFileData = [];
    @track showFileName = false;
    @track showSpinner = false;
    @track recordId;
    @track wrapper = { base64: null, fileName: null };
    @track lstWrapper = [];
    @track insertedData;
    @track setIdsToUpdate = [];
    @track newReportrecordId;
    
    @track imageUrl = 'https://zadoon1234--dev--c.documentforce.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=06822000001klUEAAY&operationContext=DELIVERY&contentId=05T22000009LezKEAS&page=0&d=/a/220000004NCb/3kYT4Cf5J4JRGfiF8phx4JaqZ7KspDGTOmPs1S6kjug&oid=00D2200000093BBEAY&dpt=null&viewId='  ;


    headerData = { 'fullName': '-', 'company': '-', 'email': '-', 'phone': '-', 'dateOfInspection': '-', 'zid': '-', 'serialVIN': '-', 'makeModel': '-', 'hours': '-', 'cityState': '-','storageStreet': '-', 'storageCity': '-', 'storageStateZipCode': '-', 'siteContactMobile': '-', 'storageCountry': '-' };
    connectedCallback() {
        this.prepareData();
        debugger;
       this.createData();
    }
    
    prepareData() {
        this.loader = true;
        try {
            getIntialData({
                parmValue: this.unitId
            })
                .then((response) => {
                    console.log(response);
                    if (response.bIsSuccess) {
                        if (response.mapResponse.objectName == 'Product2') {
                            this.mapData = response.mapResponse.dataWapper;
                            this.mapPhotoData = response.mapResponse.dataPhotoWapper;
                            console.log(this.mapDat);
                            console.log(this.mapPhotoData);
                            console.log(response.mapResponse.dataTable);

                            this.loader = false;
                            this.viewMode = false;
                            this.reportType = response.mapResponse.unitType;
                            this.unitZid =  response.mapResponse.unitZid;
                            this.newReportrecordId = this.unitId;

                            
                            
                            this.headerData[['zid']] =  this.unitZid;
                            if(response.mapResponse.unitData.Hour__c != undefined ){
                                this.headerData[['hours']] =  response.mapResponse.unitData.Hour__c;
                            }
                            this.headerData[['serialVIN']] =  response.mapResponse.unitData.Serial_Number__c+response.mapResponse.unitData.VIN__c;
                            this.headerData[['makeModel']] =  response.mapResponse.unitData.equipment__r.Name ;
                            let cityState ='';
                            if(response.mapResponse.unitData.Storage_City__c != undefined ){
                                this.cityState = response.mapResponse.unitData.Storage_City__c;
                              }
                            if(response.mapResponse.unitData.Storage_State__c != undefined){
                                this.cityState += response.mapResponse.unitData.Storage_State__c;

                                }
                            if(this.cityState != undefined){
                                this.headerData[['cityState']] =  this.cityState;
                            }
                            if(response.mapResponse.unitData.Storage_Address__c != undefined){
                                this.headerData[['storageStreet']] =  response.mapResponse.unitData.Storage_Address__c ;
                            }
                            if(response.mapResponse.unitData.Site_Contact_Mobile__c != undefined){
                                this.headerData[['siteContactMobile']] =  response.mapResponse.unitData.Site_Contact_Mobile__c ;
                            }
                            let storageStateZipCode ='';
                            if(response.mapResponse.unitData.Storage_State__c != undefined ){
                                this.storageStateZipCode = response.mapResponse.unitData.Storage_State__c + '/';
                              }
                            if(response.mapResponse.unitData.Storage_Zip_Code__c != undefined){
                                this.storageStateZipCode += response.mapResponse.unitData.Storage_Zip_Code__c;

                            }    
                            if(this.storageStateZipCode != undefined ){
                                this.headerData[['storageStateZipCode']] = this.storageStateZipCode ;
                              }
                            

                            if(response.mapResponse.unitData.Storage_Country__c != undefined){
                                this.headerData[['storageCountry']] =  response.mapResponse.unitData.Storage_Country__c ;
                            }
                            if(response.mapResponse.unitData.Storage_City__c != undefined){
                                this.headerData[['storageCity']] =  response.mapResponse.unitData.Storage_City__c ;
                            }
                           
                            
                            
                            this.headerData[['dateOfInspection']] =  new Date().toISOString().substring(0, 10);
                        }
                        else if (response.mapResponse.objectName == 'Inspection_Report__c') {
                            this.viewMode = true;
                            this.loader = false;
                            this.mapData = JSON.parse(response.mapResponse.dataTable.Unit_JSON__c);
                            this.headerData = JSON.parse(response.mapResponse.dataTable.Header_Data__c);

                        }
                        else {

                        }

                    }
                    else {

                    }

                })
                .catch((error) => {

                });
        }
        catch (error) {

        }

    }
    createData() {
        this.loader = true;
        try {
            createIntialData({
                parmValue: this.unitId
            })
                .then((response) => {
                    console.log('h',response);

                    if (response.bIsSuccess) {
                        this.newReportrecordId = response.mapResponse.newRecord;
                        

                    }
                    else {

                    }

                })
                .catch((error) => {
                    console.log('h',error);

                });
        }
        catch (error) {
            console.log('h',error);

        }

    }

    handleHeaderChange(event) {
        try {
            this.headerData[[event.target.name]] = event.target.value;
        }
        catch (e) {

        }
    }
    onChangeValue(event) {
        console.log(event.target.value);
        console.log(event.target.name);
        console.log(event.target.dataset.id);
        console.log(this.mapData);
        try {
            let tempPickList = JSON.parse(JSON.stringify(this.mapData));
            tempPickList.forEach(value => {
                if (value.tableHeader == event.target.dataset.id) {
                    value.lstLineItems.forEach(value1 => {
                        if (value1.lineItemTitle == event.target.name) {
                            console.log('ff2', JSON.stringify(value1));
                            console.log('ff2', value1.lineItemTitle);
                            console.log('ff3', value1.lineItemValue);
                            value1.lineItemValue = event.target.value;
                            console.log('ff4', value1);

                            return;


                        }
                    })
                }
            });
            this.mapData = tempPickList;

        }
        catch (error) {
            console.log(error);

        }



    }
    get options() {
        return [
            { label: 'Excellent', value: 'Excellent' },
            { label: 'Fair', value: 'Fair' },
            { label: 'Operable, needs work', value: 'Operable, needs work' },
            { label: 'inoperable', value: 'inoperable' },
            
        ];
    }

    handleSubmit() {
        this.loader = true;
        console.log(this.setIdsToUpdate);
        //const children = arr1.concat(arr2, arr3); 
        this.completeDataTest = this.mapPhotoData.concat(this.mapData) ;
        try {
            handleSaveData({
                headerData: JSON.stringify(this.headerData),
                unitData: JSON.stringify(this.completeDataTest),
                unitId: this.unitId,
                filesToInsert: JSON.stringify(this.setIdsToUpdate),
                newRecordId : this.newReportrecordId

            })
                .then((response) => {
                    if (response.bIsSuccess) {
                        this.loader = false;
                        this.showFormPage = false;
                        this.insertedData = response.mapResponse.objToCreate;
                        console.log(this.insertedData);
                        console.log(response.mapResponse);
                        //console.log(response.mapResponse.objToCreate);
                        //console.log(this.lstWrapper);
                        
                    }
                    else {

                    }

                })
                .catch((error) => {
                    console.log('rrrrrrrrr4', JSON.stringify(error));
                });
        }
        catch (error) {
            console.log('rrrrrrrrr3', error);
        }

        


    }
    openfileUpload(event) {
        let files = event.target.files;
        
        console.log(files);
        try{
            if (files.length > 0) {
                this.loader = true;
    
                for (let i = 0; i < files.length; i++) {
                    let file = event.target.files[i];
                    let fileArr;
                    console.log(file.name);
                    console.log(file.type);
                    console.log('file1',file);
                    
                    this.ShowFileData.push(file.name);
                    let tempPickList = JSON.parse(JSON.stringify(this.mapPhotoData));
                    tempPickList.forEach(value => {
                        if (value.tableHeader == event.target.dataset.id) {
                            value.lstLineItems.forEach(value1 => {
                                if (value1.lineItemTitle == event.target.name) {
                                    console.log('ff2', JSON.stringify(value1));
                                    console.log('ff2', value1.lineItemTitle);
                                    console.log('ff3', value1.lineItemValue);
                                    var str = value1.lineItemTitle;
                                    var res = str.replace(/\s+/g, "_");
                                    var fileName = file.name;
                                    var fileExt = fileName.substring( fileName.lastIndexOf('.'),fileName.length);
                                     var fileNameW = fileName.substring( 0,fileName.lastIndexOf('.'));
                                     
                                    let newFileName = 'ZID' +'_'+ this.unitZid +'_'+res+ '_'+ fileNameW +fileExt;
                                    this.handleWrapperCreation(file,newFileName);
                                    
                                    console.log('hi11',this.lstWrapper);
                                    
                                    
                                    if (value1.lineItemValue == '-') {
                                        value1.lineItemValue = newFileName;
                                    }
                                    else {
                                        value1.lineItemValue += ';';
                                        value1.lineItemValue += newFileName;
                                    }
    
                                    
    
                                    return;
    
    
                                }
                            })
                        }
                    });
                    this.mapPhotoData = tempPickList;
                    
                    console.log('ff9', this.lstWrapper);
                    //setTimeout(this.fileUploadfun(),1000);
                    setTimeout(() => {
                        this.fileUploadfun();
                    }, 3000);
                   
                    
                    
    
                }
                
                this.showFileName = true;
                this.lstWrapper = [];
            }

        }
        catch (error) {
            console.log('rrrrrrrrr3', error);
        }

        
    }
    fileUploadfun(){
        uploadFile({
            filesToInsert: JSON.stringify(this.lstWrapper[0]),
            recordId : this.newReportrecordId
            
            

        })
            .then((response) => {
                console.log(response);
                console.log(response.bIsSuccess);
                console.log(JSON.stringify(response.mapResponse));
                if (response.bIsSuccess) {
                    this.loader = false;
                    //this.showFormPage = false;
                    this.setIdsToUpdate.push(response.mapResponse.setContentDocumentLink[0]);
                    console.log('hi'+this.setIdsToUpdate);
                    
                }
                else {

                }

            })
            .catch((error) => {
                console.log('rrrrrrrrr4', JSON.stringify(error));
            });
    }

    async handleWrapperCreation(file,fileName) {
        console.log('file : ' + file);
        var reader = new FileReader()
        reader.readAsDataURL(file)
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            console.log('file : ' + base64);
            console.log('file : ' + fileName);
            let fileVar = {
                'filename': fileName,
                'base64': base64
            };
            this.lstWrapper.push(fileVar );
            console.log('sdzfdsf>>>>>', this.lstWrapper);
           // return this.lstWrapper;
        }
    }

}