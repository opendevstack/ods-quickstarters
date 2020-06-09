import sum from "../src/sum"

describe('adds 1 + 2 to equal 3', () => {
  it('add', () => {
    expect(sum(1, 2)).toBe(3);
  });
});
