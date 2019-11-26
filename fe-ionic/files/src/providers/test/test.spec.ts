import {inject, TestBed} from '@angular/core/testing';
import {HttpClientTestingModule, HttpTestingController} from '@angular/common/http/testing';

import {TestProvider} from './test';

describe('TestProvider', () => {
  let subject: TestProvider = null;
  let backend: HttpTestingController = null;


  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [
        HttpClientTestingModule
      ],
      providers: [
        TestProvider
      ]
    });
  });

  beforeEach(inject([TestProvider, HttpTestingController], (testService: TestProvider, mockBackend: HttpTestingController) => {
    subject = testService;
    backend = mockBackend;
  }));

  it('should be created', inject([TestProvider], (service: TestProvider) => {
    expect(service).toBeTruthy();
  }));


});
