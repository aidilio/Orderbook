<%@ Page Title="Home Page" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="Orderbook._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<div id="dvGrid" style="padding: 10px; width: 800px">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:GridView ID="OrderGrid" runat="server" AutoGenerateColumns="false" 
            DataKeyNames="OrderNumber" OnRowEditing="OnRowEditing" OnRowCancelingEdit="OnRowCancelingEdit" PageSize = "10" AllowPaging ="true" OnPageIndexChanging = "OnPaging"
            OnRowUpdating="OnRowUpdating" OnRowDeleting="OnRowDeleting" EmptyDataText="No orders in the system."
            Width="800">
            <Columns>
                <asp:TemplateField HeaderText="Customer Name" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblCustomerName" runat="server" Text='<%# Eval("CustomerName") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtCustomerName" runat="server" Text='<%# Eval("CustomerName") %>' Width="140"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Customer Address" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblCustomerAddress" runat="server" Text='<%# Eval("CustomerAddress") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtCustomerAddress" runat="server" Text='<%# Eval("CustomerAddress") %>' Width="140"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order Number" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblOrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order Date" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblOrderDate" runat="server" Text='<%# Eval("OrderDate") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order Description" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblOrderDescription" runat="server" Text='<%# Eval("OrderDescription") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtOrderDescription" runat="server" Text='<%# Eval("OrderDescription") %>' Width="140"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order Amount" ItemStyle-Width="150">
                    <ItemTemplate>
                        <asp:Label ID="lblOrderAmount" runat="server" Text='<%# Eval("OrderAmount") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtOrderAmount" runat="server" Text='<%# Eval("OrderAmount") %>' Width="140"></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ButtonType="Link" ShowEditButton="true" ShowDeleteButton="true"
                    ItemStyle-Width="150" />
            </Columns>
        </asp:GridView>
        <table border="1" cellpadding="10" cellspacing="10" style="border-collapse: collapse">
            <tr>
                <td style="width: 150px">
                    Customer Name:<br />
                    <asp:TextBox ID="txtCustomerName" runat="server" Width="140" />
                </td>
                <td style="width: 150px">
                    Customer Address:<br />
                    <asp:TextBox ID="txtCustomerAddress" runat="server" Width="140" />
                </td>
                <td style="width: 150px">
                    Order Description:<br />
                    <asp:TextBox ID="txtOrderDescription" runat="server" Width="140" />
                </td>
                <td style="width: 150px">
                    Order Amount:<br />
                    <asp:TextBox ID="txtOrderAmount" runat="server" Width="140" />
                </td>
                <td style="width: 150px">
                    <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="Insert" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
</div>


</asp:Content>
