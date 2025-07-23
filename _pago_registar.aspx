<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_pago_registar.aspx.cs" Inherits="sanderson.backend._pago_registar" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Registrar Pago</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxFormLayout ID="formPago" runat="server">
        <Items>
            <dx:LayoutItem Caption="Alumno">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblAlumno" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>

            <dx:LayoutItem Caption="Concepto">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblConcepto" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>

            <dx:LayoutItem Caption="Monto">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblMonto" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:LayoutItem Caption="Recargos">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblRecargo" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:LayoutItem Caption="Descuento">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblDescuento" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:LayoutItem Caption="Total a Pagar">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxLabel ID="lblMontoAPagar" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>



            <dx:LayoutItem Caption="Método de Pago">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxComboBox ID="cmbMetodoPago" runat="server">
                            <Items>
                                <dx:ListEditItem Text="Efectivo" Value="Efectivo" />
                                <dx:ListEditItem Text="Transferencia" Value="Transferencia" />
                                <dx:ListEditItem Text="Tarjeta" Value="Tarjeta" />
                            </Items>
                        </dx:ASPxComboBox>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>

            <dx:LayoutItem Caption="Referencia">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxTextBox ID="txtReferencia" runat="server" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>

            <dx:LayoutItem>
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxButton ID="btnRegistrar" runat="server" Text="Registrar Pago"
                            CssClass="btn-lila-solid" OnClick="btnRegistrar_Click" />
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
        </Items>
    </dx:ASPxFormLayout>

    <dx:ASPxHyperLink ID="lnkComprobante" runat="server" Text="Descargar Comprobante"
        Visible="false" Target="_blank" CssClass="btn-lila-outline" />
</asp:Content>
