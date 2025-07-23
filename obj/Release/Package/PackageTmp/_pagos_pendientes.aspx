<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="_pagos_pendientes.aspx.cs" Inherits="sanderson.backend._pagos_pendientes" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v21.1, Version=21.1.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainTitle" runat="server">
    <h2>Pagos pendientes</h2>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <dx:ASPxGridView ID="gvPagosPendientes" runat="server" AutoGenerateColumns="False"
        KeyFieldName="PagoId" OnCustomButtonCallback="gvPagosPendientes_CustomButtonCallback">

        <SettingsCommandButton>    
        </SettingsCommandButton>
        <Columns>
            <dx:GridViewDataTextColumn FieldName="Alumno" Caption="Alumno" Width="200" />
            <dx:GridViewDataTextColumn FieldName="Concepto" Caption="Concepto" />

            <dx:GridViewDataTextColumn FieldName="Monto" Caption="Monto Base" PropertiesTextEdit-DisplayFormatString="C2" />

            <dx:GridViewDataTextColumn FieldName="Descuento" Caption="Descuentos" PropertiesTextEdit-DisplayFormatString="C2" />
            <dx:GridViewDataTextColumn FieldName="Recargo" Caption="Recargo" PropertiesTextEdit-DisplayFormatString="C2" />
            <dx:GridViewDataTextColumn FieldName="Total" Caption="Total" PropertiesTextEdit-DisplayFormatString="C2" />
            <dx:GridViewDataTextColumn FieldName="FechaVencimiento" Caption="Vencimiento" PropertiesTextEdit-DisplayFormatString="d" />
            <dx:GridViewDataTextColumn FieldName="DiasVencidos" Caption="Días Vencidos">
        
            </dx:GridViewDataTextColumn>
          <dx:GridViewDataColumn>
              <DataItemTemplate>

                  <a href='<%# GetRouteUrl("_pagos_pagar" ,new { pago_id=(Guid)Eval("PagoId")}) %>' class="btn btn-primary text-white" > Registrar pago</a>
              </DataItemTemplate>
          </dx:GridViewDataColumn>
        </Columns>
        <SettingsSearchPanel Visible="true" />
    </dx:ASPxGridView>
</asp:Content>
