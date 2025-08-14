<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_alumnos.aspx.cs" Inherits="sanderson.backend._alumnos" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Control de Alumnos</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="panel panel-default">
        <div class="panel-heading ">
            <h5 class=" mb-5">Listado de alumnos</h5>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class=" col-12">
                    <dx:ASPxGridView ID="gvAlumnos" runat="server" AutoGenerateColumns="False" Theme="iOS" ClientInstanceName="gvAlumnos"
                        OnDataBinding="gvAlumnos_DataBinding" KeyFieldName="alumno_id" Width="100%"
                        OnRowDeleting="gvAlumnos_RowDeleting" OnRowInserting="gvAlumnos_RowInserting"
                        OnRowUpdating="gvAlumnos_RowUpdating" OnRowValidating="gvAlumnos_RowValidating">
                        <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                        <SettingsPager PageSize="20" />
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

                            <NewButton Text="Nuevo Alumno" RenderMode="Button">
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

                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" />
                        <SettingsSearchPanel Visible="true" />
                        <SettingsPopup>
                            <EditForm Width="900" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" />
                        </SettingsPopup>
                        <SettingsDetail ShowDetailRow="true" />
                        <Columns>

                            <dx:GridViewDataColumn Caption="Acciones" VisibleIndex="0" Width="250" >
                                
                                <DataItemTemplate>
                                    <div class="d-flex flex-wrap align-items-center" style="gap: 0.5rem;">
                                        <!-- Editar -->
                                        <a href="javascript:void(0);"
                                            onclick="gvAlumnos.StartEditRow(<%# Container.VisibleIndex %>);"
                                            class="btn btn-sm text-white"
                                            style="background-color: #6f42c1; min-width: 36px; min-height: 36px; display: flex; align-items: center; justify-content: center;"
                                            title="Editar">
                                            <i class="fas fa-edit"></i>
                                        </a>

                                        <!-- Eliminar (con confirmación SweetAlert) -->
                                        <a href="javascript:void(0);"
                                            onclick="confirmDelete(<%# Container.VisibleIndex %>);"
                                            class="btn btn-sm text-white"
                                            style="background-color: #8e44ad; min-width: 36px; min-height: 36px; display: flex; align-items: center; justify-content: center;"
                                            title="Eliminar">
                                            <i class="fas fa-trash"></i>
                                        </a>

                                        <!-- Pagos Pendientes -->
                                        <a href='<%# GetRouteUrl("_pagos_pendiente_alumno", new { alumno_id = (Guid)Eval("alumno_id") }) %>'
                                            class="btn btn-sm text-white"
                                            style="background-color: #9b59b6; min-width: 36px; min-height: 36px; display: flex; align-items: center; justify-content: center;"
                                            title="Pagos Pendientes">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </a>

                                        <!-- Pagos Realizados -->
                                        <a href='<%# GetRouteUrl("_pagos_realizados_alumno", new { alumno_id = (Guid)Eval("alumno_id") }) %>'
                                            class="btn btn-sm text-white"
                                            style="background-color: #a569bd; min-width: 36px; min-height: 36px; display: flex; align-items: center; justify-content: center;"
                                            title="Pagos Realizados">
                                            <i class="fas fa-file-invoice"></i>
                                        </a>
                                    </div>
                                </DataItemTemplate>


                                <HeaderTemplate>
                                    <div class="d-flex flex-wrap gap-1 align-items-center">
                                        <!-- Nuevo -->
                                        <a href="javascript:void(0);"
                                            onclick="gvAlumnos.AddNewRow();"
                                            class="btn btn-sm btn-primary text-white"
                                            title="Nuevo">
                                            <i class="fas fa-plus"></i>
                                        </a>
                                    </div>
                                </HeaderTemplate>
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataColumn>
                           
                            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre" VisibleIndex="1" Width="200" AdaptivePriority="1">
                                <PropertiesTextEdit MaxLength="50">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El nombre es obligatorio." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="apellido_paterno" Caption="Apellido Paterno" VisibleIndex="2" Width="200" AdaptivePriority="2">
                                <PropertiesTextEdit MaxLength="50">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El apellido paterno es obligatorio." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="apellido_materno" Caption="Apellido Materno" VisibleIndex="3" Width="200" AdaptivePriority="3">
                                <PropertiesTextEdit MaxLength="50">
                                    <ValidationSettings ErrorText="Máximo 50 caracteres." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataDateColumn FieldName="fecha_nacimiento" Caption="Fecha Nacimiento" VisibleIndex="4" Width="150" AdaptivePriority="4">
                                <PropertiesDateEdit>
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="La fecha de nacimiento es obligatoria." ErrorTextPosition="Bottom" />
                                </PropertiesDateEdit>
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="curp" Caption="CURP" VisibleIndex="5" Width="180" AdaptivePriority="5">
                                <PropertiesTextEdit MaxLength="18">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="La CURP es obligatoria." ErrorTextPosition="Bottom"
                                        RegularExpression-ValidationExpression="^[A-Z]{4}\d{6}[A-Z0-9]{8}$"
                                        RegularExpression-ErrorText="Formato de CURP inválido. Debe tener 18 caracteres." />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Nivel" Caption="Nivel" VisibleIndex="6" Width="100" Visible="true" AdaptivePriority="6">
                                <EditFormSettings Visible="false" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Grado" Caption="Grado" VisibleIndex="6" Width="100" Visible="true" AdaptivePriority="7">
                                <EditFormSettings Visible="false" />
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataComboBoxColumn FieldName="GradoNivel" Caption="Nivel" VisibleIndex="6" Width="100" Visible="false">
                                <PropertiesComboBox ValueType="System.String" TextField="Nivel" ValueField="GradoNivel" DataSourceID="dsGradoNivel">

                                    <Columns>
                                        <dx:ListBoxColumn FieldName="Nivel" Caption="Nivel" />
                                        <dx:ListBoxColumn FieldName="Grado" Caption="Grado" />

                                    </Columns>
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="Seleccione un nivel educativo." ErrorTextPosition="Bottom" />
                                </PropertiesComboBox>
                                <EditFormSettings Visible="True" />
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

                            <dx:GridViewDataTextColumn FieldName="alergias" Caption="Alergias" VisibleIndex="7" Width="200" AdaptivePriority="8">
                                <PropertiesTextEdit MaxLength="200">
                                    <ValidationSettings ErrorText="Máximo 200 caracteres." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="observaciones" Caption="Observaciones" VisibleIndex="8" Width="200" AdaptivePriority="9">
                                <PropertiesTextEdit MaxLength="300">
                                    <ValidationSettings ErrorText="Máximo 300 caracteres." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="telefono_emergencia" Caption="Tel. Emergencia" VisibleIndex="9" Width="130" AdaptivePriority="10">
                                <PropertiesTextEdit MaxLength="10">
                                    <ValidationSettings ErrorText="Debe ser un número de 10 dígitos." ErrorTextPosition="Bottom"
                                        RegularExpression-ErrorText="Bottom"
                                        RegularExpression-ValidationExpression="^\d{10}$" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="contacto_emergencia" Caption="Contacto Emergencia" VisibleIndex="10" Width="200" AdaptivePriority="11">
                                <PropertiesTextEdit MaxLength="100">
                                    <ValidationSettings ErrorText="Máximo 100 caracteres." ErrorTextPosition="Bottom" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>
                        </Columns>
                        <Templates>
                            <DetailRow>
                                <div style="border: 2px solid #D0B3F6; border-radius: 8px; padding: 15px; margin: 10px 20px; background-color: #F8F5FC;">

                                    <div class="section-title">Tutores</div>
                                    <dx:ASPxGridView ID="gvTutores" runat="server" AutoGenerateColumns="False" Theme="iOS"
                                        KeyFieldName="tutor_id" Width="100%"
                                        OnRowInserting="gvTutores_RowInserting" OnRowUpdating="gvTutores_RowUpdating"
                                        OnRowDeleting="gvTutores_RowDeleting" OnRowValidating="gvTutores_RowValidating"
                                        OnDataBinding="gvTutores_DataBinding"
                                        MasterRowKeyFieldName="alumno_id"
                                        
                                        
                                        >
                                        <SettingsEditing Mode="PopupEditForm" />

                                        <SettingsCommandButton>
                                            <EditButton Text=" " RenderMode="Button">
                                                <Styles>
                                                    <Style CssClass="btn btn-lila mb-2" Paddings-Padding="0px"></Style>
                                                </Styles>
                                                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-pencil' viewBox='0 0 16 16'><path d='M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z'/></svg>" />
                                            </EditButton>

                                            <DeleteButton Text=" " RenderMode="Button">
                                                <Styles>
                                                    <Style CssClass="btn btn-light mb-2 border border-lila" Paddings-Padding="0px"></Style>
                                                </Styles>
                                                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-trash' viewBox='0 0 16 16'><path d='M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z'/><path fill-rule='evenodd' d='M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z'/></svg>" />
                                            </DeleteButton>

                                            <NewButton Text="Agregar Tutor" RenderMode="Button">
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

                                        <SettingsDataSecurity AllowInsert="true" AllowDelete="true" AllowEdit="true" />
                                        <Columns>
                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0" Width="100" />

                                            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre">
                                                <PropertiesTextEdit MaxLength="100">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El nombre es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="apellido_paterno" Caption="Apellido Paterno">
                                                <PropertiesTextEdit MaxLength="100">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El apellido paterno es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="apellido_materno" Caption="Apellido Materno">
                                                <PropertiesTextEdit MaxLength="100" />
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="parentesco" Caption="Parentesco">
                                                <PropertiesTextEdit MaxLength="50">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El parentesco es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="telefono" Caption="Teléfono">
                                                <PropertiesTextEdit MaxLength="10">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El teléfono es obligatorio."
                                                        RegularExpression-ValidationExpression="^\d{10}$"
                                                        RegularExpression-ErrorText="Debe ser un número de 10 dígitos." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="email" Caption="Email">
                                                <PropertiesTextEdit MaxLength="100">
                                                    <ValidationSettings
                                                        RegularExpression-ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w{2,4}$"
                                                        RegularExpression-ErrorText="Formato de correo inválido." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataCheckColumn FieldName="es_principal" Caption="Principal" />
                                        </Columns>
                                        <SettingsPopup>
                                            <EditForm Width="900" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" />
                                        </SettingsPopup>
                                    </dx:ASPxGridView>
                                    <div class="section-title">Personas Autorizadas</div>
                                    <dx:ASPxGridView ID="gvPersonasAutorizadas" runat="server" AutoGenerateColumns="False" Theme="iOS"
                                        KeyFieldName="persona_id" Width="100%"
                                        OnRowInserting="gvPersonasAutorizadas_RowInserting" OnRowUpdating="gvPersonasAutorizadas_RowUpdating"
                                        OnRowDeleting="gvPersonasAutorizadas_RowDeleting" OnRowValidating="gvPersonasAutorizadas_RowValidating"
                                        OnDataBinding="gvPersonasAutorizadas_DataBinding"
                                        MasterRowKeyFieldName="alumno_id">
                                        <SettingsEditing Mode="PopupEditForm" />

                                        <SettingsCommandButton>
                                            <EditButton Text=" " RenderMode="Button">
                                                <Styles>
                                                    <Style CssClass="btn btn-lila mb-2" Paddings-Padding="0px"></Style>
                                                </Styles>
                                                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-pencil' viewBox='0 0 16 16'><path d='M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z'/></svg>" />
                                            </EditButton>

                                            <DeleteButton Text=" " RenderMode="Button">
                                                <Styles>
                                                    <Style CssClass="btn btn-light mb-2 border border-lila" Paddings-Padding="0px"></Style>
                                                </Styles>
                                                <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-trash' viewBox='0 0 16 16'><path d='M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z'/><path fill-rule='evenodd' d='M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z'/></svg>" />
                                            </DeleteButton>

                                            <NewButton Text="Agregar Persona Autorizada" RenderMode="Button">
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
                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0" Width="100" />
                                            <dx:GridViewDataTextColumn FieldName="nombre" Caption="Nombre">
                                                <PropertiesTextEdit MaxLength="100">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El nombre es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="apellido_paterno" Caption="Apellido Paterno">
                                                <PropertiesTextEdit MaxLength="100">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El apellido paterno es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="apellido_materno" Caption="Apellido Materno">
                                                <PropertiesTextEdit MaxLength="100" />
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="parentesco" Caption="Parentesco">
                                                <PropertiesTextEdit MaxLength="50">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El parentesco es obligatorio." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn FieldName="telefono" Caption="Teléfono">
                                                <PropertiesTextEdit MaxLength="10">
                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El teléfono es obligatorio."
                                                        RegularExpression-ValidationExpression="^\d{10}$"
                                                        RegularExpression-ErrorText="Debe ser un número de 10 dígitos." />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsPopup>
                                            <EditForm Width="900" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" />
                                        </SettingsPopup>
                                    </dx:ASPxGridView>
                                </div>
                            </DetailRow>
                        </Templates>
                    </dx:ASPxGridView>
                </div>
            </div>
        </div>
    </div>
    <dx:EntityServerModeDataSource ID="dsGradoNivel" runat="server" OnSelecting="EntityServerModeDataSource1_Selecting" ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" TableName="VNivelGrado" />
    <dx:EntityServerModeDataSource ID="dsEscuelas" runat="server" OnSelecting="dsEscuelas_Selecting" ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" TableName="Escuelas" />
    <script>
        function confirmDelete(rowIndex) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'Esta acción eliminará al alumno.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    gvAlumnos.DeleteRow(rowIndex);
                }
            });
        }
    </script>


</asp:Content>
