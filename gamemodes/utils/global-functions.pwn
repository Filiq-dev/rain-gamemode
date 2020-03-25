stock IsMail(const email[]) { // luata din saints 1.3
  	new len=strlen(email);
  	new cstate=0;
  	new i;
  	for(i=0;i<len;i++)
	{
	    if ((cstate==0 || cstate==1) && (email[i]>='A' && email[i]<='Z')||(email[i]>='0' && email[i]<='9') || (email[i]>='a' && email[i]<='z')  || (email[i]=='.')  || (email[i]=='-')  || (email[i]=='_'))
	    {
	    }
		else
		{
	       // Ok no A..Z,a..z,_,.,-
	       if ((cstate==0) &&(email[i]=='@'))
		   {
	          // its an @ after the name, ok state=1;
	          cstate=1;
	       }
		   else
		   {
	          // Its stuff which is not allowed
	          return false;
	       }
	 	}
	}
  	if (cstate<1) return false;
  	if (len<6) return false;
  	// A toplevel domain has only 3 to 4 signs :-)
  	if ((email[len-3]=='.') || (email[len-4]=='.') || (email[len-5]=='.')) return true;
  	return false;
}