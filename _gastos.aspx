<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_gastos.aspx.cs" Inherits="sanderson.backend._gastos" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Control de Gastos</h2>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="modal fade" id="modalEvidencia" tabindex="-1" role="dialog" aria-labelledby="modalEvidenciaLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-lila text-white">
                    <h5 class="modal-title" id="modalEvidenciaLabel">Cargar Evidencia</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Seleccione archivo(s) de evidencia:</label>
                        <dx:ASPxUploadControl ID="uploadEvidencia" runat="server" UploadMode="Advanced"
                            ShowUploadButton="True" ShowProgressPanel="True" Width="100%"
                            NullText="Seleccione archivos..." Multiple="True"
                            OnFileUploadComplete="uploadEvidencia_FileUploadComplete">
                            <AdvancedModeSettings EnableMultiSelect="True" EnableFileList="True" EnableDragAndDrop="True" />
                            <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.png,.pdf,.doc,.docx,.xls,.xlsx">
                                <ErrorStyle ForeColor="Red" />
                            </ValidationSettings>
                            <ClientSideEvents
                                FilesUploadComplete="function(s, e) { 
                                if(e.errorText.length == 0) {
                                  
                                    $('#modalEvidencia').modal('hide');
                                    gvGastos.Refresh();
                                }
                            }" />
                        </dx:ASPxUploadControl>
                        <small class="form-text text-muted">Formatos permitidos: JPG, PNG, PDF, DOC, XLS. Tamaño máximo: 4MB por archivo.</small>
                    </div>
                    <div class="form-group">
                        <label>Archivos cargados:</label>
                        <dx:ASPxGridView ID="gvArchivos" runat="server" Width="100%" AutoGenerateColumns="False" ClientInstanceName="gvArchivos"
                            KeyFieldName="IdEvidencia" OnDataBinding="gvArchivos_DataBinding"
                            OnRowDeleting="gvArchivos_RowDeleting">
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="NombreArchivo" Caption="Archivo" Width="60%">
                                    <DataItemTemplate>
                                        <a href='<%# GetRouteUrl("DescargarEvidenciaRoute", new { idEvidencia = Eval("IdEvidencia") }) %>'
                                            class="btn btn-sm btn-lila text-white"
                                            title="Descargar Evidencia">
                                            <i class="fas fa-download"></i>
                                        </a>

                                    </DataItemTemplate>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Tamanio" Caption="Tamaño" Width="20%">
                                    <PropertiesTextEdit DisplayFormatString="{0:n0} KB" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataDateColumn FieldName="FechaCarga" Caption="Fecha" Width="20%" />
                                <dx:GridViewCommandColumn Width="50px" ShowDeleteButton="true" />
                            </Columns>
                            <SettingsPager Mode="ShowAllRecords" />
                        </dx:ASPxGridView>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>


    <div class="panel panel-default">
        <div class="panel-heading">
            <h5 class="mb-5">Registro de Gastos</h5>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-12">
                    <dx:ASPxGridView ID="gvGastos" runat="server" AutoGenerateColumns="False" Theme="iOS"
                        OnDataBinding="gvGastos_DataBinding" KeyFieldName="IdGasto" Width="100%"
                        OnRowDeleting="gvGastos_RowDeleting" OnRowInserting="gvGastos_RowInserting"
                        OnRowUpdating="gvGastos_RowUpdating" OnRowValidating="gvGastos_RowValidating"
                        OnCustomButtonCallback="gvGastos_CustomButtonCallback">

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

                            <NewButton Text="Nuevo Gasto" RenderMode="Button">
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
                        <ClientSideEvents CustomButtonClick="function(s, e) {
                            if(e.buttonID == 'btnEvidencia') {
                                // Guardar el IdGasto seleccionado
                                hfIdGasto.Set('IdGasto', s.GetRowKey(e.visibleIndex));
                                // Mostrar el modal

                               cbGuardarIdGasto.PerformCallback(s.GetRowKey(e.visibleIndex));
                                $('#modalEvidencia').modal('show');
                                // Cargar los archivos existentes
                                gvArchivos.Refresh();
                            }
                        }" />


                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" />
                        <SettingsSearchPanel Visible="true" />
                        <SettingsPopup>
                            <EditForm Width="900" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" />
                        </SettingsPopup>

                        <Columns>
                            <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" ShowDeleteButton="true" VisibleIndex="0" Width="100" />

                            <dx:GridViewDataComboBoxColumn FieldName="IdEscuela" Caption="Escuela" VisibleIndex="1" Width="200">
                                <PropertiesComboBox ValueType="System.Guid" ValueField="escuela_id" TextField="nombre" DataSourceID="dsEscuelas">
                                    <ValidationSettings RequiredField-IsRequired="false" ErrorText="Seleccione una escuela (opcional para gastos generales)" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>

                            <dx:GridViewDataComboBoxColumn FieldName="IdTipoGasto" Caption="Tipo de Gasto" VisibleIndex="2" Width="200">
                                <PropertiesComboBox ValueType="System.Int32" ValueField="IdTipoGasto" TextField="Nombre" DataSourceID="dsTiposGasto">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="Seleccione un tipo de gasto" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>

                            <dx:GridViewDataTextColumn FieldName="Concepto" Caption="Concepto" VisibleIndex="3" Width="250">
                                <PropertiesTextEdit MaxLength="200">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="El concepto es obligatorio" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataSpinEditColumn FieldName="Monto" Caption="Monto ($)" VisibleIndex="4" Width="120">
                                <PropertiesSpinEdit NumberType="Float" DisplayFormatString="c2" MinValue="0" MaxValue="10000000">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="Ingrese un monto válido" />
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>

                            <dx:GridViewDataTextColumn FieldName="Justificacion" Caption="Justificación" VisibleIndex="5" Width="250">
                                <PropertiesTextEdit MaxLength="500">
                                    <ValidationSettings RequiredField-IsRequired="true" ErrorText="La justificación es obligatoria" />
                                </PropertiesTextEdit>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataCheckColumn FieldName="EsGastoGeneral" Caption="Gasto General" VisibleIndex="6" Width="120">
                                <PropertiesCheckEdit>
                                    <ValidationSettings RequiredField-IsRequired="false" />
                                </PropertiesCheckEdit>
                            </dx:GridViewDataCheckColumn>

                            <dx:GridViewDataDateColumn FieldName="FechaGasto" Caption="Fecha " VisibleIndex="7" Width="150">
                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" EditFormat="DateTime">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </PropertiesDateEdit>
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="FechaRegistro" Caption="Fecha Registro" VisibleIndex="7" Width="150">
                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" EditFormat="DateTime">
                                    <ValidationSettings RequiredField-IsRequired="true" />
                                </PropertiesDateEdit>
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataDateColumn>

                            <dx:GridViewDataTextColumn FieldName="UsuarioRegistro" Caption="Registrado por" VisibleIndex="8" Width="150" ReadOnly="true">
                                <PropertiesTextEdit>
                                    <ValidationSettings RequiredField-IsRequired="false" />
                                </PropertiesTextEdit>
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>


                            <dx:GridViewCommandColumn VisibleIndex="0" Width="150px">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnEvidencia" Text="Evidencia">

                                        <Styles>
                                            <Style CssClass="btn btn-info mb-2" Paddings-Padding="0px"></Style>
                                        </Styles>
                                        <Image Url="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' class='bi bi-paperclip' viewBox='0 0 16 16'><path d='M4.5 3a2.5 2.5 0 0 1 5 0v9a1.5 1.5 0 0 1-3 0V5a.5.5 0 0 1 1 0v7a.5.5 0 0 0 1 0V3a1.5 1.5 0 1 0-3 0v9a2.5 2.5 0 0 0 5 0V5a.5.5 0 0 1 1 0v7a3.5 3.5 0 1 1-7 0V3z'/></svg>" />

                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                        </Columns>
                    </dx:ASPxGridView>
                </div>
            </div>
        </div>
    </div>

    <dx:ASPxCallback ID="cbGuardarIdGasto" runat="server" ClientInstanceName="cbGuardarIdGasto"
        OnCallback="cbGuardarIdGasto_Callback">
    </dx:ASPxCallback>
    <dx:ASPxHiddenField ID="hfIdGasto" runat="server" ClientInstanceName="hfIdGasto"></dx:ASPxHiddenField>
    <!-- DataSources -->
    <dx:EntityServerModeDataSource ID="dsEscuelas" runat="server"
        ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities" OnSelecting="dsEscuelas_Selecting" />
    <dx:EntityServerModeDataSource ID="dsTiposGasto" runat="server"
        ContextTypeName="sanderson.backend.DAL.EscuelasSandersonSatoriEntities"
        TableName="TiposGasto" OnSelecting="dsTiposGasto_Selecting" />
</asp:Content>
