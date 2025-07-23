<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_pagos_realizados_byalumno.aspx.cs" Inherits="sanderson.backend._pagos_realizados_byalumno" %>


<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Pagos Registrados</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <div class="container-fluid">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h5 class="m-0 font-weight-bold text-primary">Consulta de Pagos Recibidos</h5>
                <div class=" alert-info">
                    <%=$"{alumno.nombre} {alumno.apellido_paterno} {alumno.apellido_materno}"%>
                </div>

            </div>
            <div class="card-body">
                <!-- Filtros -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-light">
                                <h6 class="m-0 font-weight-bold">Filtros de Búsqueda</h6>
                            </div>
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group col-md-3">
                                        <dx:ASPxLabel ID="lblFechaDesde" runat="server" Text="Fecha Desde:" AssociatedControlID="deFechaDesde"></dx:ASPxLabel>
                                        <dx:ASPxDateEdit ID="deFechaDesde" runat="server" Width="100%" Theme="Moderno"
                                            DisplayFormatString="dd/MM/yyyy" EditFormat="Custom" EditFormatString="dd/MM/yyyy">
                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                        </dx:ASPxDateEdit>
                                    </div>
                                    <div class="form-group col-md-3">
                                        <dx:ASPxLabel ID="lblFechaHasta" runat="server" Text="Fecha Hasta:" AssociatedControlID="deFechaHasta"></dx:ASPxLabel>
                                        <dx:ASPxDateEdit ID="deFechaHasta" runat="server" Width="100%" Theme="Moderno"
                                            DisplayFormatString="dd/MM/yyyy" EditFormat="Custom" EditFormatString="dd/MM/yyyy">
                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                        </dx:ASPxDateEdit>
                                    </div>
                                    <div class="form-group col-md-2 align-self-end">
                                        <dx:ASPxButton ID="btnFiltrar" runat="server" Text="Filtrar" Theme="Moderno"
                                            CssClass="btn btn-primary" Width="100%" OnClick="btnFiltrar_Click">
                                            <Image IconID="actions_apply_16x16"></Image>
                                        </dx:ASPxButton>
                                    </div>

                                    <div class="form-group col-md-2 align-self-end">
                                        <dx:ASPxButton ID="btnExportarExcel" runat="server" Text="Exportar Excel" Theme="Moderno"
                                            CssClass="btn btn-success" Width="100%" OnClick="btnExportarExcel_Click">
                                            <Image IconID="export_exporttoxls_16x16"></Image>
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Grid de resultados -->
                <div class="row">
                    <div class="col-md-12">
                        <dx:ASPxGridView ID="gvPagos" runat="server" AutoGenerateColumns="False" Width="100%"
                            KeyFieldName="pago_id;alumno_id" Theme="Moderno" EnableCallBacks="true">
                            <Settings ShowGroupPanel="false" ShowFilterRow="true" ShowFooter="true"
                                VerticalScrollBarMode="Auto" VerticalScrollableHeight="400" />
                            <SettingsSearchPanel Visible="true" ShowApplyButton="true" />
                            <SettingsPager PageSize="20" Position="Bottom">
                                <PageSizeItemSettings Visible="true" Items="10,20,50,100" />
                            </SettingsPager>
                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" />
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="pago_id" Visible="false"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="alumno_id" Visible="false"></dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="alumno" Caption="Alumno" Width="200px" FixedStyle="Left">
                                    <Settings AllowAutoFilterTextInputTimer="False" />
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="nivel" Caption="Nivel" Width="120px">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Center"></CellStyle>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="grado" Caption="Grado" Width="100px">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Center"></CellStyle>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="monto" Caption="Monto" Width="120px"
                                    PropertiesTextEdit-DisplayFormatString="c">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                    <FooterCellStyle HorizontalAlign="Right" Font-Bold="true"></FooterCellStyle>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="descuento" Caption="Descuento" Width="120px"
                                    PropertiesTextEdit-DisplayFormatString="c">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                    <FooterCellStyle HorizontalAlign="Right" Font-Bold="true"></FooterCellStyle>
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="recargo" Caption="Recargo" Width="120px"
                                    PropertiesTextEdit-DisplayFormatString="c">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                    <FooterCellStyle HorizontalAlign="Right" Font-Bold="true"></FooterCellStyle>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataDateColumn FieldName="fecha_pago" Caption="Fecha" Width="120px"
                                    PropertiesDateEdit-DisplayFormatString="yyyy-MM-dd">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                    <FooterCellStyle HorizontalAlign="Right" Font-Bold="true"></FooterCellStyle>
                                </dx:GridViewDataDateColumn>


                                
                                <dx:GridViewDataTextColumn FieldName="monto_pagado" Caption="Monto Pagado" Width="120px"
                                    PropertiesTextEdit-DisplayFormatString="c">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                    <FooterCellStyle HorizontalAlign="Right" Font-Bold="true"></FooterCellStyle>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="descripcion" Caption="Descripción" Width="250px">
                                    <Settings AllowAutoFilterTextInputTimer="False" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataHyperLinkColumn Caption="Acciones" Width="100px">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <CellStyle HorizontalAlign="Center"></CellStyle>
                                    <DataItemTemplate>
                                        <div class="btn-group">
                                            <a href='<%# ResolveUrl("~/handler/handlerReport.ashx?id=" + Eval("pago_id")) %>'
                                                class="btn btn-sm btn-primary text-white" title="Descargar comprobante">
                                                <i class="fas fa-file-download "></i>
                                            </a>

                                        </div>
                                    </DataItemTemplate>
                                </dx:GridViewDataHyperLinkColumn>
                            </Columns>
                            <TotalSummary>
                                <dx:ASPxSummaryItem FieldName="monto_pagado" SummaryType="Sum" DisplayFormat="Total: {0:c}" />
                            </TotalSummary>
                            <Styles>
                                <Header HorizontalAlign="Center" Font-Bold="true"></Header>
                                <Footer Font-Bold="true"></Footer>
                                <AlternatingRow Enabled="True" BackColor="#F9F9F9"></AlternatingRow>
                            </Styles>
                        </dx:ASPxGridView>

                        <!-- Exportador -->
                        <dx:ASPxGridViewExporter ID="gvExporter" runat="server" GridViewID="gvPagos"
                            FileName="PagosRecibidos" PaperKind="A4" Landscape="true">
                            <Styles>
                                <Default Font-Size="10pt"></Default>
                                <Header Font-Bold="true" HorizontalAlign="Center"></Header>
                                <Cell HorizontalAlign="Right"></Cell>
                                <AlternatingRowCell Enabled="True" BackColor="#F9F9F9"></AlternatingRowCell>
                            </Styles>
                        </dx:ASPxGridViewExporter>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para detalle -->




</asp:Content>
