component
{

	public ZipUtility function init()
	{
		return this;
	}

	public array function extractFiles( required binary File )
	{
		var ResponseArray = [];
		var ZipInputStream = getZipInputStream( File=arguments.File );
		var ZipEntry = ZipInputStream.getNextEntry();
		while( !isNull( ZipEntry ))
		{
			if( !ZipEntry.isDirectory() )
			{
				var ByteArrayOutputStream = getByteArrayOutputStream();
				var Buffer = getByteArray( Size=1024 );
				var ChunkSize = ZipInputStream.read( Buffer );
				while( ChunkSize > 0 )
				{
					ByteArrayOutputStream.write( Buffer, 0, ChunkSize );
					ChunkSize = ZipInputStream.read( Buffer );
				}
				arrayAppend( ResponseArray, ByteArrayOutputStream.toByteArray() );
			}
			ZipInputStream.closeEntry();
			ZipEntry = ZipInputStream.getNextEntry();
		}
		ZipInputStream.close();
		return ResponseArray;
	}

	private binary function getByteArray( required numeric Size )
	{
		return createObject( "java", "java.lang.reflect.Array" ).newInstance( getByteArrayOutputStream().toByteArray().getClass().getComponentType(), arguments.Size );
	}

	private any function getByteArrayInputStream( required binary File )
	{
		return createObject( "java", "java.io.ByteArrayInputStream" ).init( arguments.File );
	}

	private any function getByteArrayOutputStream()
	{
		return createObject( "java", "java.io.ByteArrayOutputStream" ).init();
	}

	private any function getZipInputStream( required binary File )
	{
		return createObject( "java", "java.util.zip.ZipInputStream" ).init( getByteArrayInputStream( arguments.File ));
	}

}
