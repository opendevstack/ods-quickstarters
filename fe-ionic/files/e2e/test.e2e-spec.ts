import {browser, element, by} from 'protractor';

describe('Test E2E', () => {


  beforeEach(() => {
    browser.get('');
    browser.driver.sleep(600);
  });


  it('should be displayed properly', () => {

    browser.controlFlow().execute(function () {
      expect(element(by.css('ion-tabs'))
        .isDisplayed())
        .toBeTruthy();
    });

  });


  it('should open the about tab', () => {

    browser.get('');

    element(by.css('#tab-t0-1')).click();

    browser.driver.sleep(600);

    expect(element(by.css('page-about')).isDisplayed())
      .toBeTruthy();

    expect(element(by.css('page-home')).isDisplayed())
      .toBeFalsy();

  });

  it('should open the contact tab', () => {

    browser.get('');

    element(by.css('#tab-t0-2')).click();

    browser.driver.sleep(600);

    expect(element(by.css('page-contact')).isDisplayed())
      .toBeTruthy();

    expect(element(by.css('page-home')).isDisplayed())
      .toBeFalsy();

  });

});
