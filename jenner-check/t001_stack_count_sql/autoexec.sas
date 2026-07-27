options obs=100;   /* cap input rows for the captured run */
/* Sol 1 reads sd1.have via LIBNAME sd1; the upstream points sd1 at d:/sd1.
   For a self-contained run we point sd1 at WORK so the inline DATALINES
   dataset resolves without any external disk. */
libname sd1 (work);
