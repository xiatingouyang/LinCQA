#include <istream>
#include <string>
#include <vector>
#include<fstream>


using namespace std;



vector<string> readCSVRow(const string &row) {

    const int UnquotedField = 0;
    const int QuotedField = 1;
    const int QuotedQuote = 2;

    
    int state = UnquotedField;
    const char *vinit[] = {""};             
    vector<string> fields(vinit, end(vinit));
    size_t i = 0; // index of the current field
    for (char c : row) {
        switch (state) {
            case UnquotedField:
                switch (c) {
                    case ',': // end of field
                              fields.push_back(""); i++;
                              break;
                    case '"': state = QuotedField;
                              break;
                    default:  fields[i].push_back(c);
                              break; }
                break;
                case QuotedField:
                switch (c) {
                    case '"': state = QuotedQuote;
                              break;
                    default:  fields[i].push_back(c);
                              break; }
                break;
            case QuotedQuote:
                switch (c) {
                    case ',': // , after closing quote
                              fields.push_back(""); i++;
                              state = UnquotedField;
                              break;
                    case '"': // "" -> "
                              fields[i].push_back('"');
                              state = QuotedField;
                              break;
                    default:  // end of quote
                              state = UnquotedField;
                              break; }
                break;
        }
    }
    return fields;
}


/// Read CSV file, Excel dialect. Accept "quoted fields ""with quotes"""
vector<vector<string> > readCSV(istream &in) {
    vector<vector<string> > table;
    string row;
    getline(in, row);
    while (!in.eof()) {
        getline(in, row);
        if (in.bad() || in.fail()) {
            break;
        }
        vector<string> fields = readCSVRow(row);
        int size = fields.size();
        for(int index = 0; index < size; index++){
          if (index < size - 1){
            printf("\"%s\",", fields[index].c_str());
          }
          else{
            printf("\"%s\"\n", fields[index].c_str());
          }
        }
        table.push_back(fields);
    }
    return table;
}


int main(int argc, char *argv[]){
  
  fstream fin;
  if (argc < 2){
    return 0;
  }

  fin.open(argv[1]);
  vector<vector<string> > table = readCSV(fin);  

  return 0;
}
