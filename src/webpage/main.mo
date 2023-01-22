import Text "mo:base/Text";
actor {
    //Here comes the webpage
    stable var text_displayed : Text = "";

    type HeaderField = (Text,Text);
    type HttpRequest = {
        body : Blob;
        headers: [HeaderField];
        method : Text;
        url : Text;
    };

    type HttpResponse ={
        status_code : Nat16;
        headers : [HeaderField];
        body : Blob;
    };
    public query func http_request(request : HttpRequest) : async HttpResponse{
        let response = {
            body = Text.encodeUtf8(text_displayed);
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
        };

        return(response);
    };

    public func change_page_text (page_text : Text) :  async (){
        text_displayed := page_text;
        return();
    };

    public query func test_text() : async Text{
        return (text_displayed);
    }
};
