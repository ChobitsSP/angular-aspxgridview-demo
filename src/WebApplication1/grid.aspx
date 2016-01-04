<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="grid.aspx.cs" Inherits="WebApplication1.grid" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" data-ng-app="app">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="http://cdn.bootcss.com/jquery/2.1.4/jquery.min.js"></script>
    <script src="http://apps.bdimg.com/libs/angular.js/1.3.9/angular.js"></script>

</head>
<body id="ctrl" data-ng-controller="ctrl">

    <script>

        var app = angular.module('app', [])

        app.controller('ctrl', function ($scope, $compile) {
            $scope.command = '';

            $scope.nameCell = '';

            $scope.$watch('command', function (newVal) {
                console.log('command', newVal);
            });

            //$scope.setRowValues = function (fieldNames, values) {
            //    if (angular.isArray(values)) {
            //        $scope.rowValues = {};
            //        var fields = fieldNames.split(';');

            //        for (var i = 0; i < values.length && i < fields.length; i++) {
            //            $scope.rowValues[fields[i]] = values[i];
            //        }
            //    }
            //    else {
            //        $scope.rowValues = values;
            //    }
            //    return $scope.rowValues;
            //}

            $scope.setNameValue = function (json) {
                $scope.nameCell = JSON.parse(json).name;
            }

            $scope.$watch('nameCell', function (newVal) {
                $('#NameTextBox1').find('input').val(JSON.stringify({ name: $scope.nameCell }));
            }, true);
        });

        window.injector = function (id) {
            var grid = document.getElementById(id);
            var scope = angular.element(grid).scope();
            angular.element(document).injector().invoke(function ($compile) {
                $compile(grid)(scope);
            });
            return scope;
        }
    </script>
    <script src="Scripts/DevService.js"></script>

    <form id="form1" runat="server">
        <dx:ASPxGridView ID="ASPxGridView1" ClientInstanceName="grid" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" KeyFieldName="Id" Theme="Default" OnRowInserting="ASPxGridView1_RowInserting" OnRowUpdating="ASPxGridView1_RowUpdating">
            <Settings ShowGroupPanel="True" ShowFilterRow="True"></Settings>
            <Columns>
                <dx:GridViewCommandColumn ShowDeleteButton="True" VisibleIndex="0" ShowNewButtonInHeader="True" ShowEditButton="True" ShowClearFilterButton="True"></dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="Id" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="2">
                    <EditItemTemplate>
                        <div>
                            <dx:ASPxTextBox ID="NameTextBox1" ClientIDMode="Static" runat="server" Width="170px"></dx:ASPxTextBox>
                        </div>
                        <input type="text" data-ng-model="nameCell" />
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Email" VisibleIndex="3"></dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Price" VisibleIndex="4"></dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn FieldName="Created" VisibleIndex="5"></dx:GridViewDataDateColumn>
            </Columns>



            <ClientSideEvents BeginCallback="function(s,e){
                var scope = angular.element(document.getElementById('ASPxGridView1')).scope();
                scope.command = e.command;
                scope.$apply();
                window.grid_command=e.command;}"
                EndCallback="function(s,e){ 

                 var scope =  injector('ASPxGridView1');

            if(window.grid_command == 'STARTEDIT'){

                var bindFields = 'Name';

            grid.GetRowValues(grid.lastMultiSelectIndex, bindFields, function(result){
                scope.setNameValue(result);
                scope.$apply();
            });

            window.grid_command = null;
            }
            }" />
        </dx:ASPxGridView>

        <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Database1.mdf;Integrated Security=True" DeleteCommand="DELETE FROM [Table] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Table] ([Name], [Email], [Price], [Created]) VALUES (@Name, @Email, @Price, @Created)" ProviderName="System.Data.SqlClient" SelectCommand="SELECT * FROM [Table]" UpdateCommand="UPDATE [Table] SET [Name] = @Name, [Email] = @Email, [Price] = @Price, [Created] = @Created WHERE [Id] = @Id">
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Name" Type="String"></asp:Parameter>
                <asp:Parameter Name="Email" Type="String"></asp:Parameter>
                <asp:Parameter Name="Price" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="Created" Type="DateTime"></asp:Parameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String"></asp:Parameter>
                <asp:Parameter Name="Email" Type="String"></asp:Parameter>
                <asp:Parameter Name="Price" Type="Decimal"></asp:Parameter>
                <asp:Parameter Name="Created" Type="DateTime"></asp:Parameter>
                <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
            </UpdateParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
