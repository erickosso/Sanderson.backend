<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_conceptos_pago.aspx.cs" Inherits="sanderson.backend._conceptos_pago" %>


<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Conceptos de pago</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <dx:ASPxGridView ID="gvConceptos" runat="server" AutoGenerateColumns="False"
        KeyFieldName="concepto_id" OnRowInserting="gvConceptos_RowInserting" Theme="ios"
        OnRowUpdating="gvConceptos_RowUpdating" OnRowDeleting="gvConceptos_RowDeleting"
        OnDataBinding="gvConceptos_DataBinding" Width="100%">

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

            <NewButton Text="Nuevo Concepto" RenderMode="Button">
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


        <Columns>
            <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" ShowNewButtonInHeader="true" />

            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre" />

            <dx:GridViewDataTextColumn FieldName="descripcion" Caption="Descripción" />

            <dx:GridViewDataComboBoxColumn FieldName="tipo" Caption="Tipo">
                <PropertiesComboBox>
                    <Items>
                        <dx:ListEditItem Text="Inscripción" Value="Inscripcion" />
                        <dx:ListEditItem Text="Colegiatura" Value="Colegiatura" />
                        <dx:ListEditItem Text="Taller" Value="Taller" />
                        <dx:ListEditItem Text="Uniforme" Value="Uniforme" />
                        <dx:ListEditItem Text="Arbitraje" Value="Arbitraje" />
                        <dx:ListEditItem Text="Otros" Value="Otros" />
                    </Items>
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataComboBoxColumn FieldName="escuela_id" Caption="Escuela" VisibleIndex="6" Width="100" Visible="true">
                <PropertiesComboBox ValueType="System.Guid" ValueField="escuela_id" DataSourceID="dsEscuelas">

                    <Columns>
                        <dx:ListBoxColumn FieldName="nombre" Caption="Escuela" />
                    </Columns>
                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="Seleccione una escuela." ErrorTextPosition="Bottom" />
                </PropertiesComboBox>
                <EditFormSettings Visible="True" />
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataTextColumn FieldName="monto_base" Caption="Monto Base" PropertiesTextEdit-DisplayFormatString="c" />

            <dx:GridViewDataCheckColumn FieldName="aplica_descuento" Caption="Aplica Descuento" />

            <dx:GridViewDataCheckColumn FieldName="aplica_beca" Caption="Aplica Beca" />

            <dx:GridViewDataCheckColumn FieldName="activo" Caption="Activo" />
        </Columns>

        <SettingsEditing Mode="PopupEditForm" />
        <SettingsPopup>
            <EditForm Width="600" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" />
        </SettingsPopup>
    </dx:ASPxGridView>

    <dx:EntityServerModeDataSource ID="dsEscuelas" runat="server" OnSelecting="dsEscuelas_Selecting" ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" TableName="Escuelas" />

</asp:Content>
