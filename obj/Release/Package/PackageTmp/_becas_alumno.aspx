<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_becas_alumno.aspx.cs" Inherits="sanderson.backend._becas_alumno" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Becas por alumno</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%-- GridView para asignación --%>
    <dx:ASPxGridView ID="gvAlumnosBecas" runat="server" KeyFieldName="alumno_beca_id"
        OnRowInserting="gvAlumnosBecas_RowInserting" OnRowUpdating="gvAlumnosBecas_RowUpdating"
        OnRowDeleting="gvAlumnosBecas_RowDeleting" Width="100%">
        <SettingsSearchPanel Visible="true" />
        <SettingsEditing Mode="EditForm"></SettingsEditing>
        <%-- Estilo botones lila --%>
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

            <NewButton Text="Otorgar beca" RenderMode="Button">
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
            <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" ShowNewButtonInHeader="true" Caption="Acciones" />

            <dx:GridViewDataComboBoxColumn FieldName="alumno_id" Caption="Alumno" Width="25%">
                <PropertiesComboBox DataSourceID="dsAlumnos"  ValueField="alumno_id" ValueType="System.Guid">
                    <Columns>
        
                        <dx:ListBoxColumn FieldName="nombre" Caption="Nombre"></dx:ListBoxColumn>
                        <dx:ListBoxColumn FieldName="curp" Caption="curp"></dx:ListBoxColumn>
                        
                    </Columns>
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataComboBoxColumn FieldName="beca_id" Caption="Beca" Width="25%">
                <PropertiesComboBox DataSourceID="dsBecas" TextField="nombre" ValueField="beca_id" ValueType="System.Guid">
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>

            <dx:GridViewDataSpinEditColumn FieldName="porcentaje_aplicado" Caption="% Descuento" Width="15%">
                <PropertiesSpinEdit NumberType="Float" MinValue="0" MaxValue="100" Increment="5">
                    <ValidationSettings RequiredField-IsRequired="true" />
                </PropertiesSpinEdit>
            </dx:GridViewDataSpinEditColumn>

            <dx:GridViewDataDateColumn FieldName="fecha_vencimiento" Caption="Vencimiento" Width="20%">
                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy">
                    <CalendarProperties FastNavProperties-DisplayMode="Inline" />
                    <CalendarProperties FastNavProperties-DisplayMode="Inline" />
                </PropertiesDateEdit>
            </dx:GridViewDataDateColumn>

            <dx:GridViewDataCheckColumn FieldName="activo" Caption="Activa" Width="15%" />
        </Columns>
        <SettingsPopup>
            <EditForm Width="600px" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter"
                ShowHeader="true" Modal="true" />
        </SettingsPopup>
    </dx:ASPxGridView>

    <%-- DataSources --%>
    <!-- DataSources -->
    <dx:EntityServerModeDataSource ID="dsAlumnos" 
        runat="server"
        ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" 
        TableName="Alumnos" OnSelecting="dsalumno_Selecting" />
    
    <dx:EntityServerModeDataSource ID="dsBecas" runat="server"
        ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" 
        TableName="Becas" OnSelecting="dsBecas_Selecting" />
 

</asp:Content>
