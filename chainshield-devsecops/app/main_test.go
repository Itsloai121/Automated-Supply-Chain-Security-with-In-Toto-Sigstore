package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestRoot(t *testing.T) {
	recorder := httptest.NewRecorder()
	request := httptest.NewRequest(http.MethodGet, "/", nil)
	newMux().ServeHTTP(recorder, request)

	if recorder.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", recorder.Code)
	}

	var body response
	if err := json.NewDecoder(recorder.Body).Decode(&body); err != nil {
		t.Fatalf("decode response: %v", err)
	}
	if body.Service != "chainshield-demo" || body.Status != "ok" {
		t.Fatalf("unexpected response: %+v", body)
	}
}

func TestHealth(t *testing.T) {
	for _, path := range []string{"/healthz", "/readyz"} {
		recorder := httptest.NewRecorder()
		request := httptest.NewRequest(http.MethodGet, path, nil)
		newMux().ServeHTTP(recorder, request)
		if recorder.Code != http.StatusOK {
			t.Errorf("%s: expected status 200, got %d", path, recorder.Code)
		}
	}
}
