<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" CodeBehind="Default.aspx.cs" ValidateRequest="false" AutoEventWireup="true" Inherits="JohnRafaelNacional09172022._Default" %>

<script runat="server">
    //This was supposed to be inside CS file but I was having bugs I think in VS 2019
    //CodeBehind is defined CodeBehind="Default.aspx.cs"
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            this.CheckArrayCounter();
            this.AppendNamesToJSONList();
        }
        catch (Exception ex)
        {
            HttpContext.Current.Session["ExceptionHandlerMsg"] = ex.ToString();
            txtGetSessionExceptionHandlerMsg.Text = HttpContext.Current.Session["ExceptionHandlerMsg"].ToString();
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(Page, typeof(System.Web.UI.Page), "Failed", "FailedToAddItemOnArray();", true);
        }

    }

    protected void CheckArrayCounter() {
        int intArrayListCounter;
        string strArrayCounter;
        if (HttpContext.Current.Session["ArrayListCounter"].ToString() == "")
        {
            HttpContext.Current.Session["ArrayListCounter"] = "1";
        }
        else
        {
            strArrayCounter = HttpContext.Current.Session["ArrayListCounter"].ToString();
            intArrayListCounter = Int32.Parse(strArrayCounter);
            intArrayListCounter = intArrayListCounter + 1;
            HttpContext.Current.Session["ArrayListCounter"] = intArrayListCounter.ToString();
        }
    }

    protected void AppendNamesToJSONList() {
        try
        {
            this.ClearArrayItem();
            this.CreateArrayItem();
        }
        catch (Exception ex)
        {
            HttpContext.Current.Session["ExceptionHandlerMsg"] = ex.ToString();
            txtGetSessionExceptionHandlerMsg.Text = HttpContext.Current.Session["ExceptionHandlerMsg"].ToString();
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(Page, typeof(System.Web.UI.Page), "Failed", "FailedToAddItemOnArray();", true);
        }
    }

    protected void ClearArrayItem() {
        HttpContext.Current.Session["ArrayListItem"] = "";
    }

    protected void CreateArrayItem() {
        string strFirstName;
        string strLastName;
        string strArrayListCounter;

        strFirstName = txtFirstName.Text.ToUpper();
        strLastName = txtLastName.Text.ToUpper();
        strArrayListCounter = HttpContext.Current.Session["ArrayListCounter"].ToString();

        HttpContext.Current.Session["ArrayListItem"] = "" + HttpContext.Current.Session["ArrayListCounter"] + "" + ": " + "[" + strFirstName + ", " + strLastName + "]," ;

        this.ValidateArrayItem(HttpContext.Current.Session["ArrayListItem"].ToString());
    }

    protected void ValidateArrayItem(String strArrayListItem) {
        try
        {
            //if valid and not duplicate then add - process via angular
            this.AddArrayItems(strArrayListItem);
        }
        catch (Exception ex)
        {
            HttpContext.Current.Session["ExceptionHandlerMsg"] = ex.ToString();
            txtGetSessionExceptionHandlerMsg.Text = HttpContext.Current.Session["ExceptionHandlerMsg"].ToString();
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(Page, typeof(System.Web.UI.Page), "Failed", "FailedToAddItemOnArray();", true);
        }
    }

    protected void AddArrayItems(String strArrayListItem) {
        List<string> lstNamesList = new List<string>();
        //Comment this out to test exception handling
        if (HttpContext.Current.Session["ArrayList"].ToString() != "")
        {
            lstNamesList = HttpContext.Current.Session["ArrayList"] as List<string>;
        }

        //Uncomment this out to test exception handling
        //lstNamesList = HttpContext.Current.Session["ArrayList"] as List<string>;

        lstNamesList.Add(strArrayListItem);
        HttpContext.Current.Session["ArrayList"] = lstNamesList;
        txtGetArrayList.Text = HttpContext.Current.Session["ArrayList"].ToString();
        
        if (Page.IsPostBack)
        {
            this.ClearNamesFields();
            this.ClearSessionValues();
        }

        System.Web.UI.ScriptManager.RegisterClientScriptBlock(Page, typeof(System.Web.UI.Page), "Success", "ConfirmAddOfItemArray();", true);
    }

    protected void ClearNamesFields() {
        txtFirstName.Text = "";
        txtLastName.Text = "";
    }

    protected void ClearSessionValues() {
        HttpContext.Current.Session["FirstName"] = "";
        HttpContext.Current.Session["LastName"] = "";
        HttpContext.Current.Session["ExceptionHandlerMsg"] = "";
    }
</script>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%   
        //Session Creation
        if (!Page.IsPostBack)
        {
            HttpContext.Current.Session["FirstName"] = "";
            HttpContext.Current.Session["LastName"] = "";
            HttpContext.Current.Session["ArrayList"] = "";
            HttpContext.Current.Session["ArrayListItem"] = "";
            HttpContext.Current.Session["ArrayListCounter"] = "";
            HttpContext.Current.Session["ExceptionHandlerMsg"] = "";
        }
    %>
    <div class="jumbotron">
        <h1>BidOne</h1>
        <body>  
            <h2>Check Duplicates in Array List</h2> <br />  
  
            <h3>Addition</h3>   
            10 + 20 = {{10+20}}  
  
            <br /><h3>Subtraction</h3>  
            30 - 20 = {{30-20}}  
  
            <br /><h3>Multiply</h3>  
            10 * 20 = {{10*20}}  
  
            <br /><h3>Division</h3>  
            20 / 10 = {{20/10}}  
        </body>

        <asp:UpdatePanel ID="UPinformationDetails" runat="server">
        <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSubmit" />
        </Triggers>
        <ContentTemplate>
            <table id="tblInformation">
            <tbody>
                <tr>
                    <td>
                        <h3>First Name:</h3>
                        <asp:TextBox ID="txtFirstName" runat="server" placeholder="FIRST NAME" 
                         style="text-transform: uppercase;" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"   
                        ErrorMessage="First name required." ForeColor="Red"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revFirstName" runat="server" ControlToValidate="txtFirstName" ForeColor = "Red"
                        ValidationExpression="[a-zA-Z0-9]*$" ErrorMessage="*Valid characters: Alphabets and Numbers only."></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h3>Last Name:</h3>
                        <asp:TextBox ID="txtLastName" runat="server" placeholder="LAST NAME" 
                        style="text-transform: uppercase;" MaxLength="50"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"   
                        ErrorMessage="Last name required." ForeColor="Red"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revLastName" runat="server" ControlToValidate="txtLastName" ForeColor = "Red"
                        ValidationExpression="[a-zA-Z0-9]*$" ErrorMessage="*Valid characters: Alphabets and Numbers only."></asp:RegularExpressionValidator>
                    </td>
                </tr>
            </tbody>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>

        <div>
        <table id="tblButtons">
            <tbody>
                <tr>
                    <td>
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click"/>
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
    </div>

    <div class="row">
        <asp:TextBox ID="txtGetSessionExceptionHandlerMsg" runat="server" Visible="False"></asp:TextBox>
        <asp:TextBox ID="txtGetArrayList" runat="server" Visible="False"></asp:TextBox>
    </div>

    <%--Javscripts Declaration--%>
    
    <script type="text/javascript">
        $(document).ready(function () {
            
        });

        function ConfirmAddOfItemArray() {
            Swal.fire(
                'Good job!',
                'Name added successfully.',
                'success'
            )

            //Generate JSON File everytime user adds
            SaveToJSON();
        }

        function FailedToAddItemOnArray() {
            var getSessionValue = document.getElementById("<%=txtGetSessionExceptionHandlerMsg.ClientID %>").value
            console.log("Error: " + getSessionValue);
            Swal.fire(
                'Oops!',
                'Failed to add names. Please try again.',
                'error'
            )
        }

        function SaveToJSON() {
            var arrayListTest = document.getElementById("<%=txtGetArrayList.ClientID %>").value
            var arrayList = ["[1] Juan,Ramizer", "[2] Michael,Jackson", "[3] Kobe,Bryant"];
            var arrayListString = JSON.stringify(arrayList);

            function download(content, fileName, contentType) {
                var a = document.createElement("a");
                var file = new Blob([content], { type: contentType });
                a.href = URL.createObjectURL(file);
                a.download = fileName;
                a.click();
            }
            download(arrayListString, 'JSON_Names.json', 'text/plain');
        }
    </script>


</asp:Content>
