import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type HeaderField = [string, string];
export interface HttpRequest {
  'url' : string,
  'method' : string,
  'body' : Uint8Array,
  'headers' : Array<HeaderField>,
}
export interface HttpResponse {
  'body' : Uint8Array,
  'headers' : Array<HeaderField>,
  'status_code' : number,
}
export interface _SERVICE {
  'change_page_text' : ActorMethod<[string], undefined>,
  'http_request' : ActorMethod<[HttpRequest], HttpResponse>,
  'test_text' : ActorMethod<[], string>,
}
