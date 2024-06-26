
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[_HorrusTB_EncodeStrItem] 
    @strUserId CHAR(21), 
    @binaryData VARBINARY(600)
AS
BEGIN
    UPDATE USERDATA  SET strItem = @binaryData WHERE strUserId = @strUserId;
    -- Select the updated strItem
    SELECT strItem FROM USERDATA WHERE strUserId = @strUserId;
END;