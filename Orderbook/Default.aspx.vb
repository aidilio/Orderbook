Imports System.Data
Imports System.Configuration
Imports System.Data.SqlClient


Public Class _Default
    Inherits Page

    Private Shared _constr = ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Me.BindGrid()
        End If
    End Sub

    Private Sub BindGrid()
        Dim query As String = "SELECT C.Id AS [CustomerId], C.Name AS [CustomerName], 
                                C.Address AS [CustomerAddress], 
                                O.Id AS [OrderNumber], 
                                O.Date AS [OrderDate], 
                                O.Description AS [OrderDescription], 
                                O.Amount AS [OrderAmount] 
                                FROM OrderCustomer CO
                                JOIN Customer C
                                ON CO.CustomerId = C.Id
                                JOIN OrderData O
                                ON CO.OrderId = O.Id"
        Using con As SqlConnection = New SqlConnection(_constr)
            Using sda As SqlDataAdapter = New SqlDataAdapter(query, con)
                Using ds As DataSet = New DataSet()
                    sda.Fill(ds)
                    OrderGrid.DataSource = ds
                    OrderGrid.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub Insert(ByVal sender As Object, ByVal e As EventArgs)
        Dim customerName As String = txtCustomerName.Text
        Dim customerAddress As String = txtCustomerAddress.Text
        Dim orderDescription As String = txtOrderDescription.Text
        Dim orderAmount As Int32

        Try
            orderAmount = Convert.ToInt32(txtOrderAmount.Text)
            ValidateAmountIsPositive(orderAmount)
        Catch ex As Exception
            ShowIncorrectOrderAmountError()
            Return
        End Try

        Dim query As String = "EXEC dbo.CreateNewOrder @CustomerName, @CustomerAddress, @OrderDescription, @OrderAmount"
        Using con As SqlConnection = New SqlConnection(_constr)
            Using cmd As SqlCommand = New SqlCommand(query)
                cmd.Parameters.AddWithValue("@CustomerName", customerName)
                cmd.Parameters.AddWithValue("@CustomerAddress", customerAddress)
                cmd.Parameters.AddWithValue("@OrderDescription", orderDescription)
                cmd.Parameters.AddWithValue("@OrderAmount", orderAmount)
                cmd.Connection = con
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using

        ClearNewOrderInput()
        Me.BindGrid()
    End Sub

    Private Sub ShowIncorrectOrderAmountError()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "alertMessage", "alert('Order amount must be a number')", True)
    End Sub

    Protected Sub OnRowEditing(sender As Object, e As GridViewEditEventArgs)
        OrderGrid.EditIndex = e.NewEditIndex
        Me.BindGrid()
    End Sub

    Protected Sub OnRowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Dim row As GridViewRow = OrderGrid.Rows(e.RowIndex)

        Dim orderNumber As Integer = Convert.ToInt32(OrderGrid.DataKeys(e.RowIndex).Values(0))
        Dim customerName As String = (TryCast(row.FindControl("txtCustomerName"), TextBox)).Text
        Dim customerAddress As String = (TryCast(row.FindControl("txtCustomerAddress"), TextBox)).Text
        Dim orderDescription As String = (TryCast(row.FindControl("txtOrderDescription"), TextBox)).Text
        Dim orderAmount As Int32

        Try
            orderAmount = Convert.ToInt32((TryCast(row.FindControl("txtOrderAmount"), TextBox)).Text)
            ValidateAmountIsPositive(orderAmount)
        Catch ex As Exception
            ShowIncorrectOrderAmountError()
            OrderGrid.EditIndex = -1
            Me.BindGrid()
            Return
        End Try


        Dim query As String = "EXEC dbo.UpdateExistingOrder @OrderId, @NewCustomerName, @NewCustomerAddress, @NewOrderDescription, @NewOrderAmount"
        Using con As SqlConnection = New SqlConnection(_constr)
            Using cmd As SqlCommand = New SqlCommand(query)
                cmd.Parameters.AddWithValue("@OrderId", orderNumber)
                cmd.Parameters.AddWithValue("@NewCustomerName", customerName)
                cmd.Parameters.AddWithValue("@NewCustomerAddress", customerAddress)
                cmd.Parameters.AddWithValue("@NewOrderDescription", orderDescription)
                cmd.Parameters.AddWithValue("@NewOrderAmount", orderAmount)
                cmd.Connection = con
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using

        OrderGrid.EditIndex = -1
        Me.BindGrid()
    End Sub

    Protected Sub OnRowCancelingEdit(sender As Object, e As EventArgs)
        OrderGrid.EditIndex = -1
        Me.BindGrid()
    End Sub


    Protected Sub OnRowDeleting(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim orderNumber As Integer = Convert.ToInt32(OrderGrid.DataKeys(e.RowIndex).Values(0))
        Dim query As String = "DELETE FROM OrderCustomer WHERE OrderId=@OrderNumber; DELETE FROM OrderData WHERE Id=@OrderNumber"
        Using con As SqlConnection = New SqlConnection(_constr)
            Using cmd As SqlCommand = New SqlCommand(query)
                cmd.Parameters.AddWithValue("@OrderNumber", orderNumber)
                cmd.Connection = con
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using
        End Using

        Me.BindGrid()
    End Sub


    Protected Sub OnPaging(ByVal sender As Object, ByVal e As GridViewPageEventArgs)
        OrderGrid.PageIndex = e.NewPageIndex
        Me.BindGrid()
    End Sub

    Private Sub ClearNewOrderInput()
        txtCustomerName.Text = ""
        txtCustomerAddress.Text = ""
        txtOrderDescription.Text = ""
        txtOrderAmount.Text = ""
    End Sub

    Private Sub ValidateAmountIsPositive(ByVal amount As Int32)
        If (amount < 0) Then
            Throw New Exception("Amount is negative.")
        End If
    End Sub
End Class