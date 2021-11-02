codeunit 59200 "PTE Complaint Credit Note"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Page Management", 'OnMailTo', '', false, false)]
    local procedure MyProcedure()
    var
        Complaint: Record "PVS Complaints";
    begin
        CreateCreditMemoFromComplaint(Complaint);
    end;

    local procedure CreateCreditMemoFromComplaint(Complaint: Record "PVS Complaints")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", Complaint."Sell-To No.");
        SalesHeader.Validate("PVS Complaint No.", Complaint."Complaint No.");
        SalesHeader.Validate("PVS Order No.", Complaint."Order No.");
        SalesHeader.Validate("PVS Order ID", Complaint.ID);
        SalesHeader.Modify(true);

        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine.Insert(true);
        SalesLine.Validate("PVS Order No.", SalesHeader."PVS Order No.");
        SalesLine.Validate("PVS ID", SalesHeader."PVS Order ID");
        SalesLine.Modify(true);
    end;
}