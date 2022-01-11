require './caeser_cipher.rb'

describe '#caeser_cipher' do
  context 'with simple string of alpha characters' do
    it 'shifts characters in string forward' do
      string = 'abc'
      expect(caeser_cipher(string, 5)).to eql('fgh')
    end

    it 'shifts characters in string backwards' do
      string = 'fgh'
      expect(caeser_cipher(string, -5)).to eql('abc')
    end

    it 'wraps from a to z when shifted backwards beyond a' do
      string = 'abc'
      expect(caeser_cipher(string, -1)).to eql('zab')
    end

    it 'wraps from z to a when shifted beyond z' do
      string = 'xyz'
      expect(caeser_cipher(string, 1)).to eql('yza')
    end
  end

  context 'with upper/lower case and puntuation' do
    it 'sensitive to original upper/lower case' do
      string = 'ABCdef'
      expect(caeser_cipher(string, 1)).to eql('BCDefg')
    end

    it 'leaves spaces and puntuation unchanged' do
      string = 'a!@# $%^&*()'
      expect(caeser_cipher(string, 5)).to eql('f!@# $%^&*()')
    end
  end

  context 'with shift greater than 26 or less then -26' do
    it 'handles shift greater than 26, wrapping from z to a' do
      string = 'abc'
      expect(caeser_cipher(string, 31)).to eql('fgh')
    end

    it 'handles shift less than -26, wrapping from a to z' do
      string = 'fgh'
      expect(caeser_cipher(string, -31)).to eql('abc')
    end
  end
end
