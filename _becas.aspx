<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_becas.aspx.cs" Inherits="sanderson.backend._becas" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Becas</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%-- GridView para asignación --%>
    <dx:ASPxGridView ID="gvBecas" runat="server" AutoGenerateColumns="False" Theme="iOS"
        KeyFieldName="beca_id" OnRowInserting="gvBecas_RowInserting"
        OnRowUpdating="gvBecas_RowUpdating" OnRowDeleting="gvBecas_RowDeleting"
        Width="100%" OnDataBinding="gvBecas_DataBinding"
        SettingsEditing-Mode="PopupEditForm">

        <%-- Estilo Botones Lila --%>
        <SettingsCommandButton>
            <EditButton Text=" " RenderMode="Button">
                <Styles>
                    <Style CssClass="btn btn-lila mb-2" Paddings-Padding="0px"></Style>
                </Styles>
                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' class='bi bi-pencil bi-white' viewBox='0 0 16 16'><path d='M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z'/></svg>" />
            </EditButton>

            <DeleteButton Text=" " RenderMode="Button">
                <Styles>
                    <Style CssClass="btn btn-light mb-2 border border-lila" Paddings-Padding="0px"></Style>
                </Styles>
                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-trash' viewBox='0 0 16 16'><path d='M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z'/><path fill-rule='evenodd' d='M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z'/></svg>" />
            </DeleteButton>

            <NewButton Text="Nueva beca" RenderMode="Button">
                <Styles>
                    <Style CssClass="btn btn-lila mb-2" Paddings-Padding="0px"></Style>
                </Styles>
            </NewButton>

            <UpdateButton Text="Guardar" RenderMode="Button">
                <Styles>
                    <Style CssClass="btn btn-lila mb-2" Paddings-Padding="0px"></Style>
                </Styles>
            </UpdateButton>

            <CancelButton Text="Cancelar" RenderMode="Button">
                <Styles>
                    <Style CssClass="btn btn-secondary mb-2" Paddings-Padding="0px"></Style>
                </Styles>
                </CancelButton>
        </SettingsCommandButton>
        <SettingsSearchPanel Visible="true" />
        <Columns>
            <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" ShowNewButtonInHeader="true" Caption="Acciones" />

            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre" Width="200px">
                <PropertiesTextEdit>
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesTextEdit>
            </dx:GridViewDataTextColumn>

            <dx:GridViewDataComboBoxColumn FieldName="tipo" Caption="Tipo">
                <PropertiesComboBox>
                    <Items>
                        <dx:ListEditItem Text="SEPH" Value="SEPH" />
                        <dx:ListEditItem Text="Deportiva" Value="Deportiva" />
                        <dx:ListEditItem Text="Hermanos" Value="Hermanos" />
                        <dx:ListEditItem Text="Trabajador" Value="Trabajador" />
                        <dx:ListEditItem Text="Especial" Value="Especial" />
                    </Items>
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataSpinEditColumn FieldName="porcentaje" Caption="Porcentaje" Width="100px">
                <PropertiesSpinEdit NumberType="Float" MinValue="0" MaxValue="100" Increment="5">
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesSpinEdit>
            </dx:GridViewDataSpinEditColumn>

            <dx:GridViewDataTextColumn FieldName="descripcion" Caption="Descripción" />

            <dx:GridViewDataCheckColumn FieldName="activo" Caption="Activa" Width="80px" />
        </Columns>

        <SettingsPopup>
            <EditForm Width="600px" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter"
                ShowHeader="true" Modal="true" />
        </SettingsPopup>

    
    </dx:ASPxGridView>


</asp:Content>
