<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_cortes_caja.aspx.cs" Inherits="sanderson.backend._cortes_caja" %>


<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h3>Cortes de Caja</h3>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
        Nuevo Corte de Caja
    </button>

    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Corte de caja</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <dx:ASPxFormLayout ID="flNuevoCorte" runat="server" ColCount="2">
                        <Items>
                            <dx:LayoutItem Caption="Escuela">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox ID="cbEscuelas" runat="server" ValueType="System.Guid"
                                            ValueField="escuela_id" TextField="nombre" Width="100%">
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Fecha">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxDateEdit ID="deFecha" runat="server" Width="100%">
                                        </dx:ASPxDateEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                            <dx:LayoutItem Caption="Observaciones" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxMemo ID="mmObservaciones" runat="server" Width="100%" Rows="4">
                                        </dx:ASPxMemo>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem ShowCaption="False" ColSpan="2">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxButton ID="btnAbrirCorte" runat="server" Text="Realizar Corte"
                                            AutoPostBack="false" Width="150px">
                                            <ClientSideEvents Click="function(s,e){ if(ASPxClientEdit.ValidateGroup('vgCorte')) { cp.PerformCallback('abrir'); } }" />
                                        </dx:ASPxButton>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:ASPxFormLayout>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxGridView ID="gvCortesAbiertos" runat="server" Width="100%"
        AutoGenerateColumns="False" KeyFieldName="corte_id">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="EscuelaNombre" Caption="Escuela" />
            <dx:GridViewDataDateColumn FieldName="fecha_corte" Caption="Fecha" />
            <dx:GridViewDataTextColumn FieldName="NombreUsuario" Caption="Responsable" />
            <dx:GridViewDataTextColumn FieldName="total_ingresos" Caption="Ingresos"
                PropertiesTextEdit-DisplayFormatString="c" />
            <dx:GridViewDataTextColumn FieldName="total_gastos" Caption="Gastos"
                PropertiesTextEdit-DisplayFormatString="c" />

            <dx:GridViewDataTextColumn Caption="Acciones">
                <DataItemTemplate>
                    <dx:ASPxButton ID="btnCerrar" runat="server" Text="Cerrar"
                        CommandArgument='<%# Eval("corte_id") %>' OnClick="btnCerrar_Click" />
                </DataItemTemplate>
            </dx:GridViewDataTextColumn>
        </Columns>

        <SettingsDetail ShowDetailRow="true" />
        <Templates>
            <DetailRow>
                <dx:ASPxPageControl runat="server" ID="pageControl" Width="100%" EnableCallBacks="true">
                    <TabPages>
                        <dx:TabPage Text="Egresos" Visible="true">
                            <ContentCollection>
                                <dx:ContentControl>
                                    <dx:ASPxGridView ID="gvIngresos" runat="server" KeyFieldName="IdGasto" OnDataBinding="gvIngresos_DataBinding">
                                        <Columns>
                                            <dx:GridViewDataColumn FieldName="IdGasto"></dx:GridViewDataColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                </dx:ContentControl>
                            </ContentCollection>
                        </dx:TabPage>
                        <dx:TabPage Text="Ingresos" Visible="true">
                            <ContentCollection>
                                <dx:ContentControl>
                                    <dx:ASPxGridView ID="gvEgresos" runat="server" OnDataBinding="gvEgresos_DataBinding" KeyFieldName="pago_id">
                                        <Columns>
                                            <dx:GridViewDataColumn FieldName="pago_id"></dx:GridViewDataColumn>
                                            <dx:GridViewDataColumn FieldName=""></dx:GridViewDataColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                </dx:ContentControl>
                            </ContentCollection>
                        </dx:TabPage>
                    </TabPages>
                </dx:ASPxPageControl>
            </DetailRow>
        </Templates>
    </dx:ASPxGridView>
    <dx:ASPxCallbackPanel ID="cpMain" runat="server" Width="100%"
        OnCallback="cpMain_Callback" ClientInstanceName="cp">
        <ClientSideEvents EndCallback="function (s,e){alert('corte realizado');window.reload;}" />

    </dx:ASPxCallbackPanel>

</asp:Content>
