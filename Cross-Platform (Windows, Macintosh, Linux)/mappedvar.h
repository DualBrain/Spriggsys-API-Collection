#include <map>

const std::string WHITESPACE = " \n\r\t\f\v";
std::string ltrim(const std::string& s)
{
    size_t start = s.find_first_not_of(WHITESPACE);
    return (start == std::string::npos) ? "" : s.substr(start);
}
 
std::string rtrim(const std::string& s)
{
    size_t end = s.find_last_not_of(WHITESPACE);
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}
 
std::string trim(const std::string& s)
{
    return rtrim(ltrim(s));
}

static map <string, string> environment;
int mapvar(string name, string value){
  if (!name.empty() && trim(name) != ""){
	  name = trim(name);
	  environment[name] = value;
	  return 1;
  }
  else{
	  return 0;
  }
  }

const char * getmappedvalue(string name){
	return environment[name].c_str();
}