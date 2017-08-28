# Universal Lookup Field Component for Salesforce Lightning
## Powerful lookup component for your developments

Boost the development of your custom components with a new powerful lookup component. It looks like a standard one, pretty easy to customize and works everywhere – even in Salesforce1.

It look like standard field and could be used with Standard and Custom Objects.

<p align="center">
  <img width="90%" src="https://image.ibb.co/fT921a/Aura_7.jpg" alt="lookupField">
</p>
***

### Installation

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Optionally, you can install it as <a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t0Y000001QMwU">unmanaged package</a>.
Also available as <a href="">managed package on AppExhange</a>.

***

```html
<aura:attribute name="selectedId" type="String"/>

<l_lookup:Lookup objectType = "Account" 
                 label = "Customer"
                 selectedRecordId = "{! v.selectedId }"
                 readOnly = "false"
                 showFiveRecent = "false"
                 widthPX="400px">
</l_lookup:Lookup>

```

***

### How to use it

Custom Lookup component field has 6 attributes.

#### Main attributes:	
  * __objectType__ - API name of Salesforce Object. Could be Standard or Custom. 
  * __selectedRecordId__ - variable that will contain Id of selected record.

#### Optional attributes:
  * __label__ - label. Default is label from Object.
  * __widthPX__ - width of field. Default is ‘300px’.
  * __readOnly__ - is field editavle. Default is false.
  * __showFiveRecent__ - feature from standard lookup field, showed 5 recently viewed records. Default is true.

  <p align="center">
    <img width="250" src="https://image.ibb.co/fZFEEv/Aura_3.jpg" alt="showLastViewed">
  </p>
