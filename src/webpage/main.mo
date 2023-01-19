import Text "mo:base/Text";
actor {
    //Here comes the webpage
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
            body = Text.encodeUtf8("Hello World");
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
        };

        return(response);
    } 
};
