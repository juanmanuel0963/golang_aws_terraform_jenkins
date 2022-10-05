package main

import (
	"log"
	"net/http"
	"testing"
)

var (
	SERVICE_URL = "https://99590g38jk.execute-api.us-east-1.amazonaws.com/contacts_get_by_company_id_romantic_shark"
	ACCESS_KEY  = ""
	SECRET_KEY  = ""
)

// Test without AWS Signature
func Test_without_aws_signature(t *testing.T) {

	//https://docs.aws.amazon.com/general/latest/gr/sigv4-signed-request-examples.html#sig-v4-examples-post
	//https://github.com/aws/aws-sdk-go/tree/main/aws/signer/v4

	t.Run("GET_request_auth", func(t *testing.T) {

		//GET request---------------------------------------------------

		client := http.Client{}
		req, err := http.NewRequest("GET", SERVICE_URL, nil)

		if err != nil {
			message := "Unsuccessfull GET request to " + SERVICE_URL
			t.Fatal(message)
			log.Fatal(message)
			t.Errorf(message)
		}

		resp, err := client.Do(req)

		if err != nil {
			message := "Unsuccessfull GET request to " + SERVICE_URL
			t.Fatal(message)
			log.Fatal(message)
			t.Errorf(message)
		}

		//Response code 403 or 404-----------------------------------------------

		expectCode403 := 403
		expectCode404 := 404
		gotCode := resp.StatusCode

		if expect, got := true, gotCode == expectCode403 || gotCode == expectCode404; expect != got {
			t.Errorf("Response code gotten not expected. Expected %v or %v, got %v", expectCode403, expectCode404, gotCode)
		}
	})

}
